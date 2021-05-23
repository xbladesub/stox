//
//  StoxError.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation

protocol StoxError: Error {
    var description: String { get }
}

enum ListsError: StoxError {
    
    case invalidListName(input: String)
    case invalidListURL(input: String)
    case listAlreadyExists(input: String)
    case createDataEmpty(kind: Create.RequestKind)
    case noSavedLists
    case noListsFound
    case listNotFound(listName: String)
    case fetchListFailed(listName: String)
    
    var description: String {
        switch self {
        case let .invalidListName(input): return "Invalid list name: \(input)\n"
        case let .invalidListURL(input): return "Invalid URL: \(input)\n"
        case let .listAlreadyExists(input): return "List '\(input)' already exists\n"
        case let .createDataEmpty(kind): return "List \(kind.rawValue) shouldn't be empty!\n"
        case .noSavedLists: return "No saved lists\n"
        case let .listNotFound(listName):
            return "\nList '\(listName)' not found\n"
        case .noListsFound: return "No lists found\n"
        case let .fetchListFailed(name): return "Can't fetch '\(name)'\n"
        }
    }
}

enum ExportError: StoxError {
    
    case invalidExportPath
    
    var description: String {
        switch self {
        case .invalidExportPath: return "Invalid export parth\n"
        }
    }
}

enum TickersFetcherError: StoxError {
    
    case noTickersForURL(URL)
    case noInternetConnection
    case cantProcessScreenerURL
    
    var description: String {
        switch self {
        case let .noTickersForURL(url):
            return "No tickers found for \(url.absoluteString)\n"
        case .noInternetConnection:
            return "No internet connection\n"
        case .cantProcessScreenerURL:
            return "Can't process screener URL\n"
        }
    }
}
