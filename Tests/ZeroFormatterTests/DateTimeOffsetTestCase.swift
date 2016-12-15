//
//  DateTimeOffsetTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/16.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

class DateTimeOffsetTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Serialize
    
    func testSerializeDateTimeOffset() {
        let testData = DateTimeOffset(timeIntervalSince1970: 123.456789012, secondsFromGMT: -9 * 60 * 60)
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b,
            0xe4, 0xfd
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testSerializeDateTimeOffsetOptional() {
        let testData: DateTimeOffset? = DateTimeOffset(timeIntervalSince1970: 123.456789012, secondsFromGMT: -9 * 60 * 60)
        
        let expected: [UInt8] = [
            0x01,
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b,
            0xe4, 0xfd
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    // MARK: - Deserialize
    
    func testDeserializeDateTimeOffset() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b,
            0xe4, 0xfd
        ]
        
        let expectedTimeInterval: TimeInterval = 123.456789012
        let expectedSecondsFromGMT = -9 * 60 * 60
        let actual: DateTimeOffset = ZeroFormatter.deserialize(testData.toData())
        
        XCTAssertEqual(actual.timeIntervalSince1970, expectedTimeInterval)
        XCTAssertEqual(actual.secondsFromGMT, expectedSecondsFromGMT)
    }
    
    func testDeserializeDateTimeOffsetOptional() {
        let testData: [UInt8] = [
            0x01,
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x14, 0x0c, 0x3a, 0x1b,
            0xe4, 0xfd
        ]
        
        let expectedTimeInterval: TimeInterval = 123.456789012
        let expectedSecondsFromGMT = -9 * 60 * 60
        let actual: DateTimeOffset? = ZeroFormatter.deserialize(testData.toData())
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.timeIntervalSince1970, expectedTimeInterval)
        XCTAssertEqual(actual!.secondsFromGMT, expectedSecondsFromGMT)
    }

}
