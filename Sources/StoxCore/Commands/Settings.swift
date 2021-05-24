//
//  Settings.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 23/05/21.
//

import Foundation
import ArgumentParser

struct Settings: ParsableCommand {
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "set",
                                                                          abstract: "Specify tickers export options")
}

// MARK: - 💠 Internal Interface

extension Settings {
    
    func run() throws {
        
        exportDirectoryRequest { directory in
            ExportManager.exportPath = directory
            LogManager.log(.currentExportDirectory(dir: directory))
        }
        
        exportFolderRequest { result in
            if result.currentDateFolder {
                ExportManager.dateFolderExport = true
                ExportManager.exportFolderName = nil
            } else {
                ExportManager.dateFolderExport = false
                ExportManager.exportFolderName = result.custom
            }
            
            LogManager.log(.exportFolder(name: result.custom))
        }
    }
}

// MARK: - 💠 Private Interface

private extension Settings {
    
    func exportDirectoryRequest(completion: @escaping (String) -> Void) {
        "New export directory: ".log(color: .cyan)
        
        let input = readLine()?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: #"\ "#, with: " ")
        
        validateDirectory(input) { result in
            switch result {
            case let .success(directory):
                completion(directory)
            case let .failure(error):
                LogManager.log(.error(error))
                exportDirectoryRequest(completion: completion)
            }
        }
    }
    
    func exportFolderRequest(completion: @escaping ((currentDateFolder: Bool, custom: String?)) -> Void) {
        "Export tickers to a specific folder? (y / n): ".log(color: .cyan)
        
        guard let input = readLine(),
              !input.isEmpty,
              (input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "y"
                || input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "n") else {
            exportFolderRequest(completion: completion)
            return
        }
        
        guard input == "y" else {
            ExportManager.dateFolderExport = false
            ExportManager.exportFolderName = nil
            return
        }
        
        "Folder name (press enter to use current date as name): ".log(color: .cyan)
        
        guard let input = readLine(),
              !input.isEmpty else {
            completion((true, nil))
            return
        }
        
        completion((false, input))
    }

    func validateDirectory(_ path: String?, completion: @escaping (Result<String, ExportError>) -> Void) {
            guard let path = path,
                  !path.isEmpty,
                  path != ExportManager.exportPath else {
                
                completion(.success(ExportManager.exportPath!))
                return
            }
            
            let url = URL(fileURLWithPath: path)

            do {
                let isDir = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory
                if let isDir = isDir, isDir {
                    completion(.success(path))
                } else {
                    completion(.failure(ExportError.invalidExportPath))
                }
            } catch {
                completion(.failure(ExportError.invalidExportPath))
            }
    }
}
