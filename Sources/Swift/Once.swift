//
//  Once.swift
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017-2019 Braden Scothern. All rights reserved.
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

#if SWIFT_PACKAGE
import OnceC
#endif
import Foundation

/// A thread safe protection mechanism to ensure that makes sure a block of code only executes once.
///
/// - Important:
///     Multiple `Once` instances should be used if there is more than one `Block` that should execute exactly once.
///     This is because a `Once` cannot protect multiple `Block`s.
///     If the same `Once` is used with multiple blocks, only the first execution of `run()` will execute.
public class Once {
    //MARK:- Types
    //MARK: Public

    /// The type of function that a `Once` can guarantee executes once.
    public typealias Block = () -> Void

    //MARK:- Properties
    //MARK: Private Static

    /// The helper funciton that is used to bridge the C and Swift functions in order to allow calling of the `Block`.
    ///
    /// This is needed in order to allow the `Block` to have context since C function pointers cannot keep swift context.
    private static let runner: OnceBlock = {
        UnsafePointer<Block>(OpaquePointer(OnceGetContextPointer()))?.pointee()
    }

    //MARK: Private
    
    // UnsafeMutablePointer must be used here to ensure that memory issues don't occur.
    // Follow the thread from this post for more information: https://forums.swift.org/t/atomic-property-wrapper-for-standard-library/30468/15
    private var onceC: UnsafeMutablePointer<OnceC>

    //MARK:- Init
    //MARK: Public
    
    /// Create a `Once` that ensurse a block only executes once.
    public init() {
        onceC = .allocate(capacity: 1)
        onceC.initialize(to:  OnceCCreate())
    }
    
    deinit {
        onceC.deinitialize(count: 1)
        onceC.deallocate()
    }

    //MARK:- Funcs
    //MARK: Public

    /// The funciton that runs the given `Block` if the `Once` hasn't already executed.
    ///
    /// - Parameter block: The `Block` that should be executed once.
    public func runOnce(_ block: Block) {
        withoutActuallyEscaping(block) { block in
            var block = block
            withUnsafePointer(to: &block) { block in
                OnceCRun(onceC, Once.runner, block)
            }
        }
    }
}
