//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

/// A type that holds the argument's definition, value and expected definitions
public protocol Argument
{
    
    /// All argument definitions expected to find while parsing
    static var expectedDefinitions: [ArgumentDefinition] { get }
    /// Number of expected positional arguments given the parsed `currentArguments`. Called multiple times, as each argument is parsed. Optional, default implementation returns 0
    static func expectedPositionalArguments(currentArguments: [ArgumentMagics.Argument]) -> UInt

    init(definition: ArgumentDefinition, value: String?)

    var definition: ArgumentDefinition { get }
    var value: String? { get set }
}

public extension Argument
{
    static func expectedPositionalArguments(currentArguments: [ArgumentMagics.Argument]) -> UInt { 0 }
}

