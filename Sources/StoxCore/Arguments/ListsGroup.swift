//
//  ListsGroup.swift
//  StoxCore
//
//  Created by Nikolai Shelekhov on 21/05/21.
//

import ArgumentParser

struct ListsGroup: ParsableArguments {
    
    @Flag(name: .customShort("r"), help: "Display only names and URLs of lists")
    var review: Bool = false
    
    @Flag(name: .customShort("e"), help: "Export fetched tickers")
    var export: Bool = false
    
    @Flag(name: .customShort("f"), help: "Create export folder")
    var folder: Bool = false
    
    @Option(name: .customShort("p"), help: "Export path. Default: Desktop", completion: .directory)
    var exportPath: String?
}
