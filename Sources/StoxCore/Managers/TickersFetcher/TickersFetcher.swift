//
//  TickersFetcher.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

import Foundation
import Reachability

// MARK: - ⛩ Type Definitions

typealias TickersData = [String: [String]]
typealias Completion = ((_ data: [TickersData], _ error: Error?) -> Void)

class TickersFetcher: TickersFetcherType {
    
    // MARK: - 🔶 Private Properties
    
    private var isReachable: Bool { (try? Reachability().connection != .unavailable) ?? false }
    
    private let downloadGroup = DispatchGroup()
    
    private let rangeTemplates: [TickersRangeTemplate] = [
        .init(left: "s=m&t=", right: "'>&nbsp"),
        .init(left: "m&ty=c&t=", right: "'><br>&nbsp"),
        .init(left: "quote.ashx?t=", right: "&ty=c&p=d&b=1")
    ]
    
    private var tickers: [TickersData] = []
    
    // MARK: - 🔷 Internal Properties
    
    var onProgress: Progress?
    
    var onCompleted: Completion?
}

// MARK: - 💠 Internal Interface

extension TickersFetcher {
    
    func fetchLists(lists: [ListItem]) {
        
        guard isReachable else {
            DispatchQueue.main.async {
                self.onCompleted?([], TickersFetcherError.noInternetConnection)
            }
            return
        }
        
        DispatchQueue.global().async { [self] in
            lists.forEach { fetch(item: $0) }
            
            downloadGroup.notify(queue: .main) { [weak self] in
                self?.onCompleted?(tickers, nil)
            }
        }
    }
}

// MARK: - 💠 Private Interface

private extension TickersFetcher {
    
    func fetch(item: ListItem) {
        
        downloadGroup.enter()
        
        do {
            let htmlString = try String(contentsOf: item.url)
            let tickersData = try processHTML(item: item, htmlString: htmlString)
            tickers.append(tickersData)
            downloadGroup.leave()
        } catch {
            if let error = error as? StoxError {
                LogManager.log(.error(error))
            } else {
                LogManager.log(.error(TickersFetcherError.cantProcessScreenerURL))
            }
            
            downloadGroup.leave()
        }
        
        downloadGroup.wait()
    }

    func processHTML(item: ListItem, htmlString: String) throws -> TickersData {
        
        var tickers = [String]()
        
        rangeTemplates.forEach { template in
            let leftRanges = htmlString.ranges(of: template.left)
            let rightRanges = htmlString.ranges(of: template.right)
            
            let ranges = zip(leftRanges, rightRanges)
            
            ranges.forEach {
                let finalRange = $0.upperBound..<$1.lowerBound
                let stock = String(describing: htmlString)[finalRange]
                if !tickers.contains(String(stock)) {
                    tickers.append(String(stock))
                }
            }
        }
        
        guard !tickers.isEmpty else {
             throw TickersFetcherError.noTickersForURL(item.url)
        }
        
        return [item.name: tickers]
    }
}
