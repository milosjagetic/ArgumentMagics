//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

/// A type that defines an argument
public protocol ArgumentDefinition
{
    /// Argument's long name eg. 'some-argument', when used in a call: 'program --some-argument'
    var name: String { get }
    /// Argument's short name eg. 's', when used in a call: 'program -a'
    var shortName: String? { get }
    /// Should the argument have a value attached. If it doesn't the parser throws an error
    var shouldHaveValue: Bool { get }
    // TODO: Remove isRequired since it does not sufficiently constrain the behaviour. Should be replaced with some kind of block or something, because some arguments can be required in certain cases and not in others
    /// Should the parameter be present at all. If it's not the parser throws an error. Optional, default value returns `false`
    func isRequired<T: Argument>(parsedArguments: [T]) -> Bool
}

public extension ArgumentDefinition
{
    var argName: String { "--\(name)" }
    var argShortName: String? { shortName != nil ? "-\(shortName!)" : nil }
    
    func isRequired<T: Argument>(parsedArguments: [T]) -> Bool  { false }
}


