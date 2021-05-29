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
    case fetchingLists(names: [String])
    case lists(T)
    case listExported(name: String, path: String)
    case currentExportDirectory(dir: String)
    case exportFolder(name: String?)
    case error(StoxError)
}

struct LogManager { }

// MARK: - 💠 Public Interface

extension LogManager {
    
    static func log(_ type: LogType<Any>) {
        switch type {
        
        case let .listCreation(item):
            "\n💠 New list created 💠\n\n".log(color: .green)
            print(
                """
     USAGE:
     ❖ stox \(item.name, color: .green) (view tickers from this list)
     ❖ stox \(item.name, color: .green) -e (export tickers)
     ❖ stox \(item.name, color: .green) -del (delete list)
     ❖ stox --help (more options)
     """)
            
        case let .listsDeletion(names):
            names.forEach { "List '\($0)' deleted\n".log(color: .red, bold: true) }
            
        case .availableLists:
            print("\nAvalable lists:")
            ListsManager.lists.forEach { "\($0.name)\n".log(color: .cyan) }
            
        case let .lists(tickerLists):
            if let items = tickerLists as? [ListItem] {
                items.forEach { "\($0.name) - \($0.url)\n".log(color: .cyan) }
            } else if let tickers = tickerLists as? TickersData {
                guard !tickers.isEmpty else { return }
                
                tickers.forEach {
                    "📄 \($0.key, color: .default):\n\($0.value.joined(separator: " "), color: .cyan)\n\n".log(color: .cyan)
                }
            }
            
        case let .fetchingLists(listNames):
            let names = listNames.joined(separator: ", ")
            "Fetching lists...: \(names, color: .default)\n\n".log(color: .cyan)
            
        case let .listExported(name, path):
            "'\(name, color: .default)\("'", color: .green) \("exported to", color: .green) \(path, color: .default) ✅\n\n".log(color: .green)
            
        case let .currentExportDirectory(dir):
            "Current export directory: \(dir, color: .default) 📂\n".log(color: .green)
            
        case let .exportFolder(name):
            if let name = name {
                "New tickers will be exported by default to a \(name, color: .default) \("folder", color: .green)\n".log(color: .green)
            } else {
                "New tickers will be exported by default to a folder with the name of the current date.\n".log(color: .green)
            }
            
        case let .error(error):
            error.description.log(color: .red, bold: true)
        }
    }
}
