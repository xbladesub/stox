//
//  URL+Extension.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation

extension URL {
    func isReachable(completion: @escaping (Bool) throws -> Void) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            do {
                try completion((response as? HTTPURLResponse)?.statusCode == 200)
            } catch {
                isReachable(completion: completion)
            }
        }.resume()
    }
}
