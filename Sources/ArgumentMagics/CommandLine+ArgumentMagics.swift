//
//  Arguments.swift
//  entstore-magics
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

extension CommandLine
{
    enum ParsingError: Error
    {
        case noValue(_ definition: ArgumentDefinition)
        case noArgument(_ definition: ArgumentDefinition)
    }
    
    static func parse<T: Argument>(_ argumentStrings: [String] = Self.arguments) throws -> [T]
    {
        let definitions = T.expectedDefinitions
        var parsed: [T] = []
        
        var i = 0
        while i < argumentStrings.count
        {
            let current = argumentStrings[i]
            
            if let definition = definitions.first(where: { $0.argName == current || $0.argShortName == current })
            {
                var argument = T(definition: definition, value: nil)
                
                let value = argumentStrings[safe: i + 1]
                
                if value == nil && definition.shouldHaveValue
                {
                    throw ParsingError.noValue( definition)
                }
                else if definition.shouldHaveValue
                {
                    argument.value = value
                    i += 1
                }
                
                parsed.append(argument)
            }
            
            i += 1
        }
        
        for definition in definitions
        {
            guard parsed.contains(where: { $0.definition.name == definition.name })
                    || !definition.isRequired else
            {
                throw ParsingError.noArgument(definition)
            }
        }
        
        return parsed
    }
    
}

private extension Array
{
    subscript(safe index: Int) -> Element? { index < count ? self[index] : nil }
}

