//
//  Arguments.swift
//  entstore-magics
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

private enum ParsingToken<T: Argument>
{
    case argument(T, [String])
    case string(String)
    
    var argument: T? { if case let .argument(arg, _) = self { return arg } else { return nil } }
    var underlyingStrings: [String]
    {
        switch self
        {
        case .argument(_, let array): return array
        case .string(let string): return [string]
        }
    }
}

public extension CommandLine
{
    enum ParsingError: Error
    {
        case noValue(_ definition: ArgumentDefinition)
        case missingArgument(_ definition: ArgumentDefinition)
        case unknownArgument(_ argString: String)
        case missingPositionalArguments
        case missingPath
    }
    
    /// Parses the given `argumentString`whose default value is `CommandLine.arguments`
    static func parse<T: Argument>(_ argumentStrings: [String] = Self.arguments) throws -> Arguments<T>
    {
        let definitions = T.expectedDefinitions
        var tokens: [ParsingToken<T>] = []

        guard let path = argumentStrings.first else { throw ParsingError.missingPath }
        let argumentStrings = Array(argumentStrings[1..<argumentStrings.count])
        
        var i = 0
        while i < argumentStrings.count
        {
            let current = argumentStrings[i]
            
            // find any argument definition that matches the current argument string
            if let definition = definitions.first(where: { $0.argName == current || $0.argShortName == current })
            {
                var argument = T(definition: definition, value: nil)
                
                // grab the next argument string as value
                let value = argumentStrings[safe: i + 1]
                
                if value == nil && definition.shouldHaveValue
                {
                    throw ParsingError.noValue( definition)
                }
                else if definition.shouldHaveValue
                {
                    // consume the next argument string
                    argument.value = value
                    i += 1
                }
                
                tokens.append(.argument(argument, [current, value].compactMap { $0 }))
            }
            else
            {
                tokens.append(.string(current))
            }

            i += 1
        }
        
        //expand any non parsed arguments that are together in short form (eg. -xyz -> arguments: x, y and z)
        tokens = tokens.flatMap
        { token -> [ParsingToken] in
            switch token
            {
            case .argument:
                return [token]
            case .string(let string):
                guard string.hasPrefix("-") else { return [token] }
                let withoutPrefix = String(string.suffix(from: string.index(after: string.startIndex)))
                
                // does not contain any chars who's definition is not expected
                let isValidMultiArgString = !withoutPrefix.contains(where:
                { char in
                    !definitions.contains(where: { $0.shortName == String(char) })
                })
                guard isValidMultiArgString else { return [token] }
                
                return withoutPrefix.compactMap
                { char in
                    definitions.first(where: { $0.shortName == String(char) })
                }.map { .argument(T(definition: $0, value: nil), [$0.shortName ?? ""]) }
            }
        }
        
        let expectedPositional = T.expectedPositionalArguments(currentArguments: tokens.compactMap { $0.argument })
        

        // count after which we collect positional arguments
        let posThreshold = tokens.count - Int(expectedPositional)
        guard posThreshold > 0 else { throw ParsingError.missingPositionalArguments }
        
        let positionalTokens = Array(tokens[posThreshold..<tokens.count])
        guard !positionalTokens.contains(where: { $0.argument != nil })
        else { throw ParsingError.missingPositionalArguments }
        
        let parsedPositional = positionalTokens.flatMap { $0.underlyingStrings }
        let remainingTokens = Array(tokens[0..<posThreshold])
    
        if let nonArgument = remainingTokens.first(where: { $0.argument == nil })
        {
            throw ParsingError.unknownArgument(nonArgument.underlyingStrings.first ?? "")
        }
  
        let parsed = remainingTokens.compactMap { $0.argument }
        
        
        // check required definitions
        for definition in definitions
        {
            if definition.isRequired(parsedArguments: parsed)
                && !parsed.contains(where: { $0.definition.name == definition.name })
            {
                throw ParsingError.missingArgument(definition)
            }
        }
        
        if parsedPositional.count < T.expectedPositionalArguments(currentArguments: parsed)
        {
            throw ParsingError.missingPositionalArguments
        }
        
        return Arguments(path: path, storage: parsed, positionalStorage: parsedPositional)
    }
    
}

private extension Array
{
    subscript(safe index: Int) -> Element? { index < count ? self[index] : nil }
}

