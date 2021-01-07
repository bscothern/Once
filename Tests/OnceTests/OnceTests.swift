//
//  OnceTests.swift
//  OnceTests
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017-2020 Braden Scothern. All rights reserved.
//

import XCTest
@testable import Once
#if canImport(Foundation)
import Foundation
#endif

class OnceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testOnceLooped() {
        let once = Once()
        var count: Int = 0
        for _ in 0..<1000 {
            once.runOnce {
                count += 1
            }
        }
        XCTAssertEqual(count, 1)
    }

    func testOnceConcurrent() {
        #if canImport(Foundation)
        let once = Once()
        var count: Int = 0
        DispatchQueue.concurrentPerform(iterations: 1000) { _ in
            once.runOnce {
                count += 1
            }
        }
        XCTAssertEqual(count, 1)
        #endif
    }
}
