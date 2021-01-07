//
//  Once.swift
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017-2020 Braden Scothern. All rights reserved.
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
    //MARK: Internal Static

    /// The helper funciton that is used to bridge the C and Swift functions in order to allow calling of the `Block`.
    ///
    /// This is needed in order to allow the `Block` to have context since C function pointers cannot keep swift context.
    @usableFromInline
    internal static let runner: OnceBlock = {
        OnceGetContextPointer()?.bindMemory(to: Block.self, capacity: 1).pointee()
    }

    //MARK: Internal

    // UnsafeMutablePointer must be used here to ensure that memory issues don't occur.
    // Follow the thread from this post for more information: https://forums.swift.org/t/atomic-property-wrapper-for-standard-library/30468/15
    @usableFromInline
    internal var onceC: UnsafeMutablePointer<OnceC>

    //MARK:- Init
    //MARK: Public

    /// Create a `Once` that ensurse a block only executes once.
    @inlinable
    public init() {
        onceC = .allocate(capacity: 1)
        onceC.initialize(to: OnceCCreate())
    }

    @inlinable
    deinit {
        onceC.deinitialize(count: 1)
        onceC.deallocate()
    }

    //MARK:- Funcs
    //MARK: Public

    /// The funciton that runs the given `Block` if the `Once` hasn't already executed.
    ///
    /// - Parameter block: The `Block` that should be executed once.
    @inlinable
    public func runOnce(_ block: Block) {
        withoutActuallyEscaping(block) { block in
            var block = block
            withUnsafePointer(to: &block) { block in
                OnceCRun(onceC, Once.runner, block)
            }
        }
    }
}
