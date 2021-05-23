//
//  Delete.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import ArgumentParser

struct Delete: ParsableCommand {
    
    // MARK: - 🔷 Internal Properties
    
    @Argument(help: "List name/names")
    var lists: [String] = []
    
    static let configuration = CommandConfiguration(commandName: "del",
                                                    abstract: "Delete tickers lists")
}

// MARK: - 💠 Internal Interface

extension Delete {
    
    func run() throws {
        
        if lists.isEmpty {
            deleteAllRequest()
        } else {
            ListsManager.execute(.delete, names: lists)
        }
    }
}

// MARK: - 💠 Private Interface

private extension Delete {
    
    func deleteAllRequest() {
        "\nDelete all lists? (y / n): ".log(color: .cyan)
        
        guard let input = readLine(),
              !input.isEmpty,
              (input.lowercased() == "y" || input.lowercased() == "n") else {
            deleteAllRequest()
            return
        }
        
        if input == "y" { ListsManager.execute(.delete) }
    }
}
