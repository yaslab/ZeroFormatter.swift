//
//  ListTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import XCTest
import ZeroFormatter

class ListTestCase: XCTestCase {
    
    static let allTests = [
        ("testSerializeFixedSizeList", testSerializeFixedSizeList),
        ("testSerializeVariableSizeList", testSerializeVariableSizeList),
        ("testDeserializeFixedSizeList", testDeserializeFixedSizeList),
        ("testDeserializeVariableSizeList", testDeserializeVariableSizeList)
    ]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Serialize
    
    func testSerializeFixedSizeList() {
        XCTAssertNotNil(Int16.length)
        
        let testData: [Int16] = [1, 2, 3, 4, 5]
        
        let expected: [UInt8] = [
            0x05, 0x00, 0x00, 0x00,
            0x01, 0x00,
            0x02, 0x00,
            0x03, 0x00,
            0x04, 0x00,
            0x05, 0x00
        ]
        let actual = ZeroFormatter.serializeAsList(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }

    func testSerializeVariableSizeList() {
        XCTAssertNil(VariableSizeObject.length)
        
        let testData: [VariableSizeObject] = [
            VariableSizeObject(a: 2, b: "01234", c: 3),
            VariableSizeObject(a: 4, b: "567890", c: 5)
        ]
        
        let expected: [UInt8] = [
            0x57, 0x00, 0x00, 0x00, // byteSize: 87
            0x02, 0x00, 0x00, 0x00, // length: 2
            0x10, 0x00, 0x00, 0x00, // elementOffset[0]: 16
            0x33, 0x00, 0x00, 0x00, // elementOffset[1]: 51
            
            0x23, 0x00, 0x00, 0x00, // byteSize: 35
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x24, 0x00, 0x00, 0x00, // indexOffset[0]: 36
            0x28, 0x00, 0x00, 0x00, // indexOffset[1]: 40
            0x31, 0x00, 0x00, 0x00, // indexOffset[2]: 49
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3
            
            0x24, 0x00, 0x00, 0x00, // byteSize: 36
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x47, 0x00, 0x00, 0x00, // indexOffset[0]: 71
            0x4b, 0x00, 0x00, 0x00, // indexOffset[1]: 75
            0x55, 0x00, 0x00, 0x00, // indexOffset[2]: 85
            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        let actual = ZeroFormatter.serializeAsList(testData)
        
        XCTAssertEqual(actual.toArray(), expected)
    }
    
    // MARK: - Deserialize
    
    func testDeserializeFixedSizeList() {
        XCTAssertNotNil(Int16.length)
        
        let testData: [UInt8] = [
            0x05, 0x00, 0x00, 0x00,
            0x01, 0x00,
            0x02, 0x00,
            0x03, 0x00,
            0x04, 0x00,
            0x05, 0x00
        ]
        
        let expected: [Int16] = [1, 2, 3, 4, 5]
        let actual: List<Int16>? = ZeroFormatter.deserialize(testData.toData())
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.count, 5)
        XCTAssertEqual(actual![0], expected[0])
        XCTAssertEqual(actual![1], expected[1])
        XCTAssertEqual(actual![2], expected[2])
        XCTAssertEqual(actual![3], expected[3])
        XCTAssertEqual(actual![4], expected[4])
    }
    
    func testDeserializeVariableSizeList() {
        XCTAssertNil(VariableSizeObject.length)

        let testData: [UInt8] = [
            0x57, 0x00, 0x00, 0x00, // byteSize: 87
            0x02, 0x00, 0x00, 0x00, // length: 2
            0x10, 0x00, 0x00, 0x00, // elementOffset[0]: 16
            0x33, 0x00, 0x00, 0x00, // elementOffset[1]: 51
            
            0x23, 0x00, 0x00, 0x00, // byteSize: 35
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x24, 0x00, 0x00, 0x00, // indexOffset[0]: 36
            0x28, 0x00, 0x00, 0x00, // indexOffset[1]: 40
            0x31, 0x00, 0x00, 0x00, // indexOffset[2]: 49
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3
            
            0x24, 0x00, 0x00, 0x00, // byteSize: 36
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x47, 0x00, 0x00, 0x00, // indexOffset[0]: 71
            0x4b, 0x00, 0x00, 0x00, // indexOffset[1]: 75
            0x55, 0x00, 0x00, 0x00, // indexOffset[2]: 85
            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        
        let expected: [VariableSizeObject] = [
            VariableSizeObject(a: 2, b: "01234", c: 3),
            VariableSizeObject(a: 4, b: "567890", c: 5)
        ]
        let actual: List<VariableSizeObject>? = ZeroFormatter.deserialize(testData.toData())

        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.count, 2)
        XCTAssertEqual(actual![0].a, expected[0].a)
        XCTAssertEqual(actual![0].b, expected[0].b)
        XCTAssertEqual(actual![0].c, expected[0].c)
        XCTAssertEqual(actual![1].a, expected[1].a)
        XCTAssertEqual(actual![1].b, expected[1].b)
        XCTAssertEqual(actual![1].c, expected[1].c)
    }
    
}
