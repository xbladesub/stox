//
//  TickersFetcherType.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

import Foundation

// MARK: - ⛩ Type Definitions

typealias FetchTickersResult = (Result<TickersData, TickersFetcherError>) -> Void
typealias TickersData = [String: [String]]

protocol TickersFetcherType {
    
    static func fetchTickers(lists: [ListItem],
                             listsGroup: ListsGroup,
                             completion: @escaping FetchTickersResult)
}
