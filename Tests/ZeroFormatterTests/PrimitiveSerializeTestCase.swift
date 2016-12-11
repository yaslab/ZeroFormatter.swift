//
//  PrimitiveSerializeTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

class PrimitiveSerializeTestCase: XCTestCase {

    static let allTests = [
        ("testInt8", testInt8),
        ("testInt16", testInt16),
        ("testInt32", testInt32),
        ("testInt64", testInt64),
        ("testUInt8", testUInt8),
        ("testUInt16", testUInt16),
        ("testUInt32", testUInt32),
        ("testUInt64", testUInt64),
        ("testFloat", testFloat),
        ("testDouble", testDouble),
        ("testBoolFalse", testBoolFalse),
        ("testBoolTrue", testBoolTrue),
        ("testDate", testDate),
        ("testString", testString)
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInt8() {
        let testData: Int8 = 123
        
        let expected: [UInt8] = [
            0x7b
        ]
        let actual = ZeroFormatter.serialize(testData)

        XCTAssertEqual(actual.toArray(), expected)
    }

    func testInt16() {
        let testData: Int16 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testInt32() {
        let testData: Int32 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testInt64() {
        let testData: Int64 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testUInt8() {
        let testData: UInt8 = 123
        
        let expected: [UInt8] = [
            0x7b
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testUInt16() {
        let testData: UInt16 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testUInt32() {
        let testData: UInt32 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testUInt64() {
        let testData: UInt64 = 123
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testFloat() {
        let testData: Float = 123
        
        let expected: [UInt8] = [
            0x00, 0x00, 0xf6, 0x42
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testDouble() {
        let testData: Double = 123
        
        let expected: [UInt8] = [
            0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0x5e, 0x40
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testBoolFalse() {
        let testData: Bool = false
        
        let expected: [UInt8] = [
            0x00
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }

    func testBoolTrue() {
        let testData: Bool = true
        
        let expected: [UInt8] = [
            0x01
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testDate() {
        let testData = Date(timeIntervalSince1970: 123.455999970)
        
        let expected: [UInt8] = [
            0x7b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0xe2, 0x01, 0x2e, 0x1b
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    func testString() {
        let testData = "abcd"
        
        let expected: [UInt8] = [
            0x04, 0x00, 0x00, 0x00,
            0x61, 0x62, 0x63, 0x64
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
}
