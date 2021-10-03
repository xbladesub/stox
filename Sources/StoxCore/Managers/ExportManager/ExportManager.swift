//
//  ExportManager.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

import Foundation

struct ExportManager: ExportManagerType {
    
    // MARK: - 🔷 Internal Properties
    
    @Defaults("tickersExportPath", defaultValue: (NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]).first)
    static var exportPath: String?
    
    @Defaults("exportFolderName")
    static var exportFolderName: String?
    
    @Defaults("dateFolderExport", defaultValue: false)
    static var dateFolderExport: Bool!
    
    static var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    // MARK: - 🔶 Private Properties
    
    private static let exportGroup = DispatchGroup()
    
    private static var exportedLists = [String]()
}

// MARK: - 💠 Internal Interface

extension ExportManager {
    
    static func exportIfNeed(tickersData: TickersData,
                             listsGroup: ListsGroup,
                             completion: @escaping ExportResult) {
            
        var exportPath: String = ""
        var customFolderName: String = ""
        var shouldExport: Bool = false
        if listsGroup.folder {
            exportFolderRequest { exportFolderName in
                customFolderName = exportFolderName
                exportPath = self.exportPath!
                shouldExport = true
                print("\n")
            }
        } else if let folderName = exportFolderName {
            customFolderName = folderName
        } else if dateFolderExport {
            customFolderName = currentDateString
        }
        
        if let path = listsGroup.exportPath {
            exportPath = path
            shouldExport = true
        } else if listsGroup.export {
            exportPath = self.exportPath!
            shouldExport = true
        }
        
        if shouldExport {
            guard !tickersData.isEmpty else { return completion(.failure(.nothingToExport)) }
            
            DispatchQueue.global().async {
                exportTickers(tickersData: tickersData,
                              exportPath: exportPath,
                              folderName: customFolderName,
                              numberOfSymbols: listsGroup.numberOfSymbols,
                              merge: listsGroup.merge)
                
                exportGroup.notify(queue: .main) {
                    let exportedPath = customFolderName.isEmpty ? exportPath : "\(exportPath)/\(customFolderName)"
                    completion(.success((exportedLists, exportedPath)))
                }
            }
        } else {
            completion(.success(nil))
        }
    }
}

// MARK: - 💠 Private Interface

private extension ExportManager {
    
    static func exportFolderRequest(completion: @escaping (String) -> Void) {
        "Export folder name: ".log(color: .cyan)
        let input = readLine()
        completion((input == nil || input?.isEmpty ?? true) ? currentDateString : input!)
    }
    
    static func exportTickers(tickersData: TickersData,
                              exportPath: String,
                              folderName: String,
                              numberOfSymbols: Int?,
                              merge: Bool) {
        
        if merge {
            exportGroup.enter()
            
            let tickersToExport: [String] = tickersData.compactMap { dict in
                if let numberOfSymbols = numberOfSymbols,
                   numberOfSymbols <= dict.value.count - 1,
                   numberOfSymbols.signum() > 0 {
                    return Array<String>(dict.value[0..<numberOfSymbols]).joined(separator: "\n")
                } else {
                    return dict.value.joined(separator: "\n")
                }
            }
            
            save(text: tickersToExport.joined(separator: "\n"),
                 toDirectory: exportPath,
                 customFolder: folderName,
                 withFileName: "Stocks \(currentDateString)") { result in
                switch result {
                case let .success(listName):
                    exportedLists.append(listName)
                    exportGroup.leave()
                case let .failure(error):
                    LogManager.log(.error(error))
                    exportGroup.leave()
                }
            }
            
            exportGroup.wait()
        } else {
            for (listName, tickers) in tickersData {
                
                exportGroup.enter()
                
                var tickersToExport: [String]!
                
                if let numberOfSymbols = numberOfSymbols,
                   numberOfSymbols <= tickers.count - 1,
                   numberOfSymbols.signum() > 0 {
                    tickersToExport = Array<String>(tickers[0..<numberOfSymbols])
                } else {
                    tickersToExport = tickers
                }
                
                save(text: tickersToExport.joined(separator: "\n"),
                     toDirectory: exportPath,
                     customFolder: folderName,
                     withFileName: listName) { result in
                    switch result {
                    case let .success(listName):
                        exportedLists.append(listName)
                        exportGroup.leave()
                    case let .failure(error):
                        LogManager.log(.error(error))
                        exportGroup.leave()
                    }
                }
                
                exportGroup.wait()
            }
        }
    }
    
    static func save(text: String,
                     toDirectory directory: String,
                     customFolder: String,
                     withFileName fileName: String,
                     completion: @escaping (Result<String, ExportError>) -> Void) {
        
        guard let filePath = append(toPath: directory,
                                    newFolderName: customFolder,
                                    withPathComponent: "\(fileName).txt") else {
            completion(.failure(.invalidExportPath))
            return
        }
        
        do {
            try text.write(toFile: filePath, atomically: true, encoding: .utf8)
            completion(.success(fileName))
        } catch {
            completion(.failure(.cantWriteTickersData(listName: fileName)))
        }
    }
    
    static func append(toPath path: String, newFolderName: String, withPathComponent pathComponent: String) -> String? {
        
        if var pathURL = URL(string: path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            
            if !newFolderName.isEmpty {
                let newPath = pathURL.appendingPathComponent(newFolderName)
                
                do {
                    try FileManager.default.createDirectory(atPath: newPath.path, withIntermediateDirectories: true, attributes: nil)
                    pathURL = newPath
                } catch {
                    LogManager.log(.error(ExportError.cantCreateDirectory(dirName: newFolderName)))
                }
            }
            
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.path
        }
        
        return nil
    }
}
