//
//  Arguments.swift
//  
//
//  Created by Milos Jagetic on 18.03.2022..
//

import Foundation

public struct Arguments<T: Argument>
{
    public enum Error: Swift.Error
    {
        case noValue(_ definition: ArgumentDefinition)
    }
    
    public let path: String
    public let storage: [T]
    public let positionalStorage: [String]
    
    public subscript(name: String) -> String?
    {
        get
        {
            return storage.first(where: { $0.definition.name == name || $0.definition.shortName == name })?.value
        }
    }
    
    public subscript(definition: ArgumentDefinition) -> String?
    {
        get { self[definition.name] }
    }
    
    public func tryValue(_ definition: ArgumentDefinition) throws -> String
    {
        guard let value = self[definition] else
        {
            throw Error.noValue(definition)
        }
        
        return value
    }
}

