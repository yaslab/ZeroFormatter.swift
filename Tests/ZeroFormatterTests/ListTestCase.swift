//
//  ListTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import XCTest
import ZeroFormatter

class ListTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFixedSizeList() {
        XCTAssertNotNil(Int16.fixedSize)
        
        let testData: [Int16] = [1, 2, 3, 4, 5]
        
        let expected: [UInt8] = [
            0x05, 0x00, 0x00, 0x00,
            0x01, 0x00,
            0x02, 0x00,
            0x03, 0x00,
            0x04, 0x00,
            0x05, 0x00
        ]
        let actual = ZeroFormatterSerializer.serializeAsList(testData)
        
        XCTAssertEqual(Array(actual), expected)
    }

    func testVariableSizeList() {
        XCTAssertNil(MyObject.fixedSize)
        
        let testData: [MyObject] = [
            MyObject(a: 2, b: "01234", c: 3),
            MyObject(a: 4, b: "567890", c: 5)
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
        let actual = ZeroFormatterSerializer.serializeAsList(testData)
        
        XCTAssertEqual(Array(actual), expected)
    }
    
}
