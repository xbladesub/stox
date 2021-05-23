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
    
    @Argument(help: "New export path", completion: .directory)
    var newPath: String?
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "dir",
                                                                          abstract: "Change export path (default: Desktop)")
}

// MARK: - 💠 Internal Interface

extension Directory {
    
    func run() throws {
        if let path = newPath {
            let url = URL(fileURLWithPath: path)
            
            do {
                let isDir = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory
                if let isDir = isDir, isDir {
                    ExportManager.exportPath = path
                    "Default export path changed:\n".log(color: .yellow)
                    print(path)
                } else {
                    throw ExportError.invalidExportPath
                }
            } catch {
                if let error = error as? ListsError {
                    LogManager.log(.error(error))
                } else {
                    LogManager.log(.error(ExportError.invalidExportPath))
                }
            }
        } else {
            "Current export path: \n".log(color: .yellow)
            print(ExportManager.exportPath ?? "\("ERROR: Export path not found", color: .red)")
        }
    }
}
