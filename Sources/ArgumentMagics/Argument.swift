//
//  File.swift
//  
//
//  Created by Milos Jagetic on 02.03.2022..
//

import Foundation

protocol Argument
{
    associatedtype Definition: ArgumentDefinition
    
    init(definition: Definition, value: String?)
    
    static var expectedDefinitions: [Definition] { get }
    
    var definition: Definition { get }
    var value: String? { get set }
}

