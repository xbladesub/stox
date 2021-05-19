//
//  Stox.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 18/05/21.
//

import ArgumentParser

public struct Stox: ParsableCommand {
    
    // MARK: - 🔷 Public Properties
    
    public static let configuration = CommandConfiguration(commandName: "stox",
                                                           abstract: "Export stock tickers from 'finviz.com' screener",
                                                           version: Constants.version,
                                                           subcommands: [Create.self])
    
    // MARK: - 👶 Init
    
    public init() {}
}
