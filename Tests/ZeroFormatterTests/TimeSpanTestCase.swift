//
//  TimeSpanTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/15.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

class TimeSpanTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Serialize
    
    func testSerializeTimeSpan() {
        let testData = TimeSpan(timeIntervalSince1970: 123.456789012)
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }

    func testSerializeTimeSpanOptional() {
        let testData: TimeSpan? = TimeSpan(timeIntervalSince1970: 123.456789012)
        
        let expected: [UInt8] = [
            0x01,
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    // MARK: - Deserialize
    
    func testDeserializeTimeSpan() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b
        ]
        
        let expected: TimeInterval = 123.456789012
        let actual: TimeSpan = ZeroFormatter.deserialize(testData.toData())
        
        XCTAssertEqual(actual.timeIntervalSince1970, expected)
    }

    func testDeserializeTimeSpanOptional() {
        let testData: [UInt8] = [
            0x01,
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b
        ]
        
        let expected: TimeInterval = 123.456789012
        let actual: TimeSpan? = ZeroFormatter.deserialize(testData.toData())
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.timeIntervalSince1970, expected)
    }
    
}
