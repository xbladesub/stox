//
//  Create.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import ArgumentParser

struct Create: ParsableCommand {
    
    // MARK: - 🔷 Public Properties
    
    static let configuration = CommandConfiguration(commandName: "create",
                                                           abstract: "Create new export list by a given screener URL")
    
    func run() throws {
        print("Export list name:")
        
        guard let listName = readLine(), !listName.isEmpty else {
            throw StoxError.invalidListName
        }
    }
}
