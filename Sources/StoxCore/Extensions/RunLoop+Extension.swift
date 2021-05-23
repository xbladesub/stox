//
//  RunLoop+Extension.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import Foundation

extension RunLoop {
    static func enter() {
        CFRunLoopRun()
    }
    
    static func exit() {
        DispatchQueue.main.async {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }
}
