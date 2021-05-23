//
//  Directory.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

import ArgumentParser
import Foundation

struct Directory: ParsableCommand {
    
    // MARK: - 🔷 Internal Properties
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "dir",
                                                                          abstract: "Display tickers export directory")
}

// MARK: - 💠 Internal Interface

extension Directory {
    
    func run() throws {
        var currentExportPath = ExportManager.exportPath!
        
        if let exportFolderName = ExportManager.exportFolderName {
            currentExportPath += "/\(exportFolderName)"
        } else if ExportManager.dateFolderExport {
            currentExportPath += "/\(ExportManager.currentDateString)"
        }
        
        LogManager.log(.currentExportDirectory(dir: currentExportPath))
    }
}
