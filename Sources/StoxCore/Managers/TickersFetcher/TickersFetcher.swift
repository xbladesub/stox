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

struct TickersFetcher: TickersFetcherType {
    
    // MARK: - 🔶 Private Properties
    
    private static var isReachable: Bool { (try? Reachability().connection != .unavailable) ?? false }
    
    private static let downloadGroup = DispatchGroup()
    
    private static let scraperRanges: [ScraperRange] = [
        .init(left: "s=m&t=", right: "'>&nbsp"),
        .init(left: "m&ty=c&t=", right: "'><br>&nbsp"),
        .init(left: "quote.ashx?t=", right: "&ty=c&p=d&b=1")
    ]
    
    private static var tickers: [TickersData] = []
}

// MARK: - 💠 Internal Interface

extension TickersFetcher {
    
    static func fetchTickers(lists: [ListItem],
                             listsGroup: ListsGroup?,
                             completion: @escaping (Result<[TickersData], TickersFetcherError>) -> Void) {
        
        guard isReachable else {
            DispatchQueue.main.async {
                completion(.failure(TickersFetcherError.noInternetConnection))
            }
            return
        }
        
        LogManager.log(.fetchingLists(names: lists.map { $0.name }))
        
        DispatchQueue.global().async { [self] in
            lists.forEach { fetch(item: $0) }
            
            downloadGroup.notify(queue: .main) {
                RunLoop.exit()
                
                completion(.success(tickers))
                tickers.removeAll()
            }
        }
        
        RunLoop.enter()
    }
}

// MARK: - 💠 Private Interface

private extension TickersFetcher {
    
    static func fetch(item: ListItem) {
        
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

    static func processHTML(item: ListItem, htmlString: String) throws -> TickersData {
        
        var tickers = [String]()
        
        scraperRanges.forEach { sRange in
            let leftRanges = htmlString.ranges(of: sRange.left)
            let rightRanges = htmlString.ranges(of: sRange.right)
            
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
