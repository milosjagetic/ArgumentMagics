//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

protocol ArgumentDefinition
{
    var name: String { get }
    var shortName: String? { get }
    var shouldHaveValue: Bool { get }
    var isRequired: Bool { get }
}

extension ArgumentDefinition
{
    var argName: String { "--\(name)" }
    var argShortName: String? { shortName != nil ? "-\(shortName!)" : nil }
    
    var isRequired: Bool { false }
}


