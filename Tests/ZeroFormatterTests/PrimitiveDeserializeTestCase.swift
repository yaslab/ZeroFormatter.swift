//
//  PrimitiveDeserializeTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016年 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

class PrimitiveDeserializeTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInt8() {
        let testData: [UInt8] = [
            0x7b
        ]

        let expected: Int8 = 123
        let actual: Int8 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testInt16() {
        let testData: [UInt8] = [
            0x7b, 0x00
        ]
        
        let expected: Int16 = 123
        let actual: Int16 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testInt32() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00
        ]
        
        let expected: Int32 = 123
        let actual: Int32 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testInt64() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        
        let expected: Int64 = 123
        let actual: Int64 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }

    func testUInt8() {
        let testData: [UInt8] = [
            0x7b
        ]
        
        let expected: UInt8 = 123
        let actual: UInt8 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testUInt16() {
        let testData: [UInt8] = [
            0x7b, 0x00
        ]
        
        let expected: UInt16 = 123
        let actual: UInt16 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testUInt32() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00
        ]
        
        let expected: UInt32 = 123
        let actual: UInt32 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testUInt64() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        
        let expected: UInt64 = 123
        let actual: UInt64 = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testFloat() {
        let testData: [UInt8] = [
            0x00, 0x00, 0xf6, 0x42
        ]
        
        let expected: Float = 123
        let actual: Float = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testDouble() {
        let testData: [UInt8] = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x5e, 0x40
        ]
        
        let expected: Double = 123
        let actual: Double = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testBoolFalse() {
        let testData: [UInt8] = [
            0x00
        ]
        
        let expected: Bool = false
        let actual: Bool = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testBoolTrue() {
        let testData: [UInt8] = [
            0x01
        ]
        
        let expected: Bool = true
        let actual: Bool = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testDate() {
        let testData: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xe2, 0x01, 0x2e, 0x1b
        ]
        
        let expected = Date(timeIntervalSince1970: 123.455999970)
        let actual: Date = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
    func testString() {
        let testData: [UInt8] = [
            0x04, 0x00, 0x00, 0x00,
            0x61, 0x62, 0x63, 0x64
        ]
        
        let expected = "abcd"
        let actual: String = ZeroFormatter.deserialize(NSData(bytes: testData))
        
        XCTAssertEqual(actual, expected)
    }
    
}
