//
//  All.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import ArgumentParser

struct All: ParsableCommand {
    
    // MARK: - 🔷 Internal Properties
    
    @OptionGroup
    var listsGroup: ListsGroup
    
    static let configuration = CommandConfiguration(commandName: "all",
                                                    abstract: "View or export all tickers from all lists")
}

// MARK: - 💠 Internal Interface

extension All {
    
    func run() throws {
        ListsManager.execute(.display, listsGroup: listsGroup)
    }
}
