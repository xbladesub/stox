//
//  ExportManager.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

import Foundation

struct ExportManager: ExportManagerType {
    
    // MARK: - 🔷 Static Properties
    
    @Defaults("exportPath", defaultValue: (NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]).first)
    static var exportPath: String?
}

// MARK: - 💠 Private Interface

private extension ExportManager {
    
    func save(text: String, toDirectory directory: String, withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        
        return nil
    }
}
