//
//  Once.swift
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//

import Foundation

public class Once {
    //MARK:- Types
    //MARK: Public
    public typealias Block = () -> Void
    
    //MARK:- Properties
    //MARK: Private Static
    private static let runner: OnceBlock = {
        UnsafePointer<Block>(OpaquePointer(GetOnceContextPointer()))?.pointee()
    }
    
    //MARK: Private
    private var onceC: OnceC = OnceCCreate()
    
    //MARK:- Funcs
    //MARK: Public
    public func run(_ block: @escaping Block) {
        var block = block
        let blockPointer =  withUnsafePointer(to: &block) { UnsafePointer($0) }
        OnceCRun(&onceC, Once.runner, blockPointer)
    }
}
