//
//  Once.swift
//  Once
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//

import Foundation
import OnceC

public class Once {
    typealias Block = () -> Void
    
    private var onceC: OnceC = OnceCCreate()
    private var block: Block? = nil
    
    func run(_ block: @escaping Block) {
        self.block = block
        OnceCRun(&onceC, runner(for: block), Unmanaged<Once>.passUnretained(self).toOpaque())
    }

    private func runner(for block: @escaping Block) -> OnceBlock {
        return {
            let once: Once = Unmanaged<Once>.fromOpaque(GetOnceContextPointer()).takeUnretainedValue()
            once.block?()
        }
    }
}
