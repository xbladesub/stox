//
//  StoxError.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

enum StoxError: Error {
    
    case invalidListName
    
    case invalidListURL
    
    var description: String {
        switch self {
        case .invalidListName:
            return "invalidListName"
        case .invalidListURL:
            return "invalidListURL"
        }
    }
}
