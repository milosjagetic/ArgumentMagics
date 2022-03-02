//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

/// A type that holds the argument's definition, value and expected definitions
protocol Argument
{
    /// A generic `ArgumentDefinition` type
    associatedtype Definition: ArgumentDefinition
    
    init(definition: Definition, value: String?)
    
    /// All argument definitions expected to find while parsing
    static var expectedDefinitions: [Definition] { get }
    
    var definition: Definition { get }
    
    var value: String? { get set }
}

