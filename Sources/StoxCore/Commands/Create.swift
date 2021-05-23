//
//  Create.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation
import ArgumentParser

struct Create: ParsableCommand {
    
    // MARK: - 🔷 Static Properties
    
    static let configuration = CommandConfiguration(commandName: "new",
                                                    abstract: "Create new tickers list by a given screener URL")
    
    // MARK: - 👶 Init
    
    init() {}
}

// MARK: - 💠 Internal Interface

extension Create {
    
    mutating func run() throws {
        
        var newListName: String!
        var newListURL: URL!
        
        try request(.name, String.self) { name in
            newListName = name
        }
        
        try request(.url, URL?.self) { url in
            newListURL = url
            RunLoop.exit()
        }

        RunLoop.enter()

        ListsManager.create(name: newListName, url: newListURL)
    }
}

// MARK: - 💠 Private Interface

private extension Create {
    
    func request<T>(_ kind: RequestKind, _ type: T.Type, compeltion: @escaping (T) -> Void) throws {
        kind.title.log(color: .cyan)
        
        guard let input = readLine(), !input.isEmpty else {
            LogManager.log(.error(ListsError.createDataEmpty(kind: kind)))
            try request(kind, type, compeltion: compeltion)
            return
        }
        
        validate(kind, input: input, type: type) { isValid, output in
            if isValid {
                compeltion(output)
            } else {
                try request(kind, type, compeltion: compeltion)
            }
        }
    }
    
    // swiftlint:disable force_try
    func validate<T>(_ kind: RequestKind, input: String, type: T.Type, completion: @escaping (Bool, T) throws -> Void) {
        switch kind {
        case .name:
            let commandNames = Stox.configuration.subcommands.map { $0._commandName }
            let listNames = ListsManager.lists.map { $0.name }
            
            if commandNames.contains(input) {
                LogManager.log(.error(ListsError.invalidListName(input: input)))
                try! completion(false, input as! T)
                return
            }
            
            if listNames.contains(input) {
                LogManager.log(.error(ListsError.listAlreadyExists(input: input)))
                try! completion(false, input as! T)
                return
            }
            
            try! completion(true, input as! T)
            
        case .url:
            input.validateURL { url in
                guard let url = url else {
                    LogManager.log(.error(ListsError.invalidListURL(input: input)))
                    try! completion(false, url as! T)
                    return
                }
                
                try! completion(true, url as! T)
            }
        }
    }
    // swiftlint:enable force_try
}

// MARK: - 🐣 Nested Objects

extension Create {
    
    enum RequestKind: String {
        case name
        case url
        
        var title: String {
            switch self {
            case .name: return "List name: "
            case .url: return "Finviz screener URL: "
            }
        }
    }
}
