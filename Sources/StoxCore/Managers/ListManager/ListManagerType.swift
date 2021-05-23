//
//  ListManagerType.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import Foundation
import ArgumentParser

protocol ListManagerType {
    
    static var lists: [ListItem] { get set }
    
    static func create(name: String, url: URL)
    
    static func execute(_ type: ListsActionType,
                        names: [String],
                        listsGroup: ListsGroup?)
}

extension ListManagerType {
    
    static func execute(_ type: ListsActionType,
                        names: [String] = [],
                        listsGroup: ListsGroup? = nil) {
        return execute(type, names: names, listsGroup: listsGroup)
    }
}
