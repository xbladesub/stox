//
//  LogManager.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

// MARK: - ⛩ Type Definitions

enum LogType<T> {
    case listCreation(ListItem)
    case listsDeletion([String])
    case availableLists
    case fetchingTickers
    case lists(T)
    case error(StoxError)
}

struct LogManager { }

// MARK: - 💠 Public Interface

extension LogManager {
    
    static func log(_ type: LogType<Any>, extraNewLine: Bool = false) {
        switch type {
        
        case let .listCreation(item):
            "\nNew list created 👍\n\n".log(color: .green)
            print(
                """
     USAGE:
     ❖ stox \(item.name, color: .green) (view tickers from this list)
     ❖ stox \(item.name, color: .green) -exp <path> (export tickers to given directory)
     ❖ stox \(item.name, color: .green) -delete (delete list)
     ❖ stox \(item.name, color: .green) -update (update screener URL)
     ❖ stox -all (view all tickers from all lists)
     ❖ stox -all -exp <path> (export all tickers from all lists to given directory)
     """)
            
        case let .listsDeletion(names):
            names.forEach { "'\($0)' deleted".log(color: .red, bold: true) }
            
        case .availableLists:
            print("\nAvalable lists:")
            ListsManager.lists.forEach { "\($0.name)\n".log(color: .cyan) }
            
        case let .lists(tickerLists):
            if let items = tickerLists as? [ListItem] {
                items.forEach { "\($0.name) - \($0.url)\n".log(color: .cyan) }
            } else if let tickers = tickerLists as? [TickersData] {
                #warning("📍 TODO")
                print(tickers)
            }
            
        case .fetchingTickers:
            "\nFetching tickers...\n\n".log(color: .cyan)
            
        case let .error(error):
            error.description.log(color: .red, bold: true)
        }
        
        if extraNewLine { print("\n") }
    }
}
