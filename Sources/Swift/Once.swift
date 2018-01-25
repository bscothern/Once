//
//  Once.swift
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
