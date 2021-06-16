//
//  List.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import ArgumentParser

struct List: ParsableCommand {
    
    // MARK: - 🔷 Internal Properties

    @Argument(help: "List name/names")
    var lists: [String] = []
    
    @OptionGroup
    var listsGroup: ListsGroup
    
    static let configuration = CommandConfiguration(commandName: "list",
                                                    abstract: "View or export tickers from given lists",
                                                    discussion: "\("View or export all if no name lists provided.", color: .cyan)")
}

// MARK: - 💠 Internal Interface

extension List {
    
    func run() throws {
        async {
            await ListsManager.execute(.display,
                                 names: lists,
                                 listsGroup: listsGroup)
        }
    }
}
