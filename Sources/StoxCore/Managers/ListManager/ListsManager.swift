//
//  ListsManager.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation

// MARK: - ⛩ Type Definitions

enum ListsActionType {
    case delete
    case display
}

struct ListsManager: ListManagerType {
    
    // MARK: - 🔷 Public Properties
    
    @CodableObject("lists", defaultValue: [])
    static var lists: [ListItem]
}

// MARK: - 💠 Private Interface

private extension ListsManager {
    
    static func listBy(_ name: String) -> ListItem? {
        lists.first(where: { $0.name == name })
    }
    
    static func validateNames(names: [String],
                              type: ListsActionType,
                              completeion: @escaping (Result<[ListItem], ListsError>) -> Void) {
        
        if names.isEmpty {
            completeion(lists.isEmpty ? .failure(type == .delete ? .noListsFound : .noSavedLists) : .success(lists))
        } else {
            let lists: [(item: ListItem?, name: String)] = names.map { (listBy($0), $0) }
            let resultLists = lists.compactMap { $0.item }
            
            if !resultLists.isEmpty {
                for list in lists where list.item == nil {
                    LogManager.log(.error(ListsError.listNotFound(listName: list.name)))
                }
            }
            
            completeion(resultLists.isEmpty ? .failure(.noListsFound) : .success(resultLists))
        }
    }
    
    static func delete(lists: [ListItem]) {
        let logNames = lists.map { $0.name }
        self.lists.removeAll()
        LogManager.log(.listsDeletion(logNames))
    }
    
    static func display(lists: [ListItem], listsGroup: ListsGroup?) {
        if listsGroup?.review ?? false {
            LogManager.log(.lists(lists))
        } else {
            TickersFetcher.fetchTickers(lists: lists,
                                        listsGroup: listsGroup) { result in
                
                switch result {
                case let .success(tickersData):
                    LogManager.log(.lists(tickersData))
                case let .failure(error):
                    LogManager.log(.error(error))
                }
            }
        }
    }
}

// MARK: - 💠 Internal Interface

extension ListsManager {
    
    static func create(name: String, url: URL) {
        let item = ListItem(name: name, url: url)
        lists.append(item)
        LogManager.log(.listCreation(item))
    }
    
    static func execute(_ type: ListsActionType,
                        names: [String] = [],
                        listsGroup: ListsGroup? = nil) {
        
        validateNames(names: names, type: type) { result in
            
            switch result {
            case let .success(lists):
                switch type {
                case .delete:
                    delete(lists: lists)
                case .display:
                    display(lists: lists, listsGroup: listsGroup)
                }
                
            case let .failure(erorr):
                LogManager.log(.error(erorr))
            }
        }
    }
}
