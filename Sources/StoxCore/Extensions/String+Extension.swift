//
//  String+Extension.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 19/05/21.
//

import Foundation
import TSCBasic

extension String {
    func log(color: TerminalController.Color, bold: Bool = false) {
        let controller = TerminalController(stream: stdoutStream)
        controller?.write(self, inColor: color, bold: bold)
    }
}

extension String {
    
    // swiftlint:disable force_try
    
    func validateURL(completion: @escaping (URL?) throws -> Void) {
        guard self.contains("finviz.com") else { return try! completion(nil) }
        
        let prefixed = self.validateScheme
        
        if let url = URL(string: prefixed) {
            url.isReachable { isReachable in
                try! completion(isReachable ? url : nil)
            }
        } else {
            try! completion(nil)
        }
    }
    
    // swiftlint:enable force_try
    
    var validateScheme: String {
        if !self.hasPrefix("http://") &&
            !self.hasPrefix("https://") {
            return "https://\(self)"
        } else {
            return self
        }
    }
}

enum ASCIIColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case `default` = "\u{001B}[0;0m"
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T, color: ASCIIColor) {
        appendInterpolation("\(color.rawValue)\(value)\(ASCIIColor.default.rawValue)")
    }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring,
                                   options: options,
                                   range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex,
                                   locale: locale) {
                ranges.append(range)
        }
        return ranges
    }
}
