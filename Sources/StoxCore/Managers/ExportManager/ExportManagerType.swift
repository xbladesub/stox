//
//  ExportManagerType.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 22/05/21.
//

// MARK: - ⛩ Type Definitions

typealias ExportResult = (Result<(names: [String], path: String)?, ExportError>) -> Void

protocol ExportManagerType {
    
    // MARK: - 🔷 Properties
    
    static var exportPath: String? { get set }
    
    static var exportFolderName: String? { get set }
    
    static var dateFolderExport: Bool! { get set }
    
    static var currentDateString: String { get }
    
    // MARK: - 💠 Handlers
    
    static func exportIfNeed(tickersData: TickersData,
                             listsGroup: ListsGroup,
                             completion: @escaping ExportResult)
}
