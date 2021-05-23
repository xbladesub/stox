//
//  Defaults.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation

private let container = UserDefaults.standard

@propertyWrapper
struct Defaults<T> {
    let key: String
    let defaultValue: T?
    
    init(_ key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T? {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
public struct CodableObject<T: Codable> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            guard
                let saved = container.object(forKey: key) as? Data,
                let decoded = try? JSONDecoder().decode(T.self, from: saved) else { return defaultValue }
            return decoded
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                container.set(encoded, forKey: key)
            }
        }
    }
}
