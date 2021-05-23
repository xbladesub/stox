//
//  ListsGroup.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import ArgumentParser

struct ListsGroup: ParsableArguments {
    
    @Flag(name: .shortAndLong, help: "Display names and URLs of lists")
    var review: Bool = false
    
    @Option(name: .customShort("p"), help: "Export path", completion: .directory)
    var exportPath: String?
}
