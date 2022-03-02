//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

/// A type that defines an argument
protocol ArgumentDefinition
{
    /// Argument's long name eg. 'some-argument', when used in a call: 'program --some-argument'
    var name: String { get }
    /// Argument's short name eg. 's', when used in a call: 'program -a'
    var shortName: String? { get }
    /// Should the argument have a value attached. If it doesn't the parser throws an error
    var shouldHaveValue: Bool { get }
    /// Should the parameter be present at all. If it's not the parser throws an error. Optional, default value is `false`
    var isRequired: Bool { get }
}

extension ArgumentDefinition
{
    var argName: String { "--\(name)" }
    var argShortName: String? { shortName != nil ? "-\(shortName!)" : nil }
    
    var isRequired: Bool { false }
}


