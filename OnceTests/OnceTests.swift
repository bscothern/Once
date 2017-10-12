//
//  OnceTests.swift
//  OnceTests
//
//  Created by Braden Scothern on 10/11/17.
//  Copyright © 2017 Braden Scothern. All rights reserved.
//

import XCTest
@testable import Once

class OnceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOnceLooped() {
        let once = Once()
        var count: Int = 0
        for _ in 0..<1000 {
            once.run {
                count += 1
            }
        }
        XCTAssert(count == 1, "Count is: \(count)")
    }
}
