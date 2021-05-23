//
//  Stox.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 18/05/21.
//

import Foundation
import ArgumentParser

public struct Stox: ParsableCommand {
    
    // MARK: - 🔷 Public Properties
    
    public static let configuration = CommandConfiguration(commandName: "stox",
                                                           abstract: "Display and export stock tickers from 'finviz.com' screener URLs",
                                                           version: Constants.version,
                                                           subcommands: [List.self,
                                                                         All.self,
                                                                         Create.self,
                                                                         Delete.self,
                                                                         Settings.self,
                                                                         Directory.self],
                                                           defaultSubcommand: List.self)
    
    // MARK: - 👶 Init
    
    public init() { }
}
