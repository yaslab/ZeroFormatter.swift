//
//  ZeroFormatterTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/26.
//  Copyright © 2016 yaslab. All rights reserved.
//

import XCTest
import ZeroFormatter

class ZeroFormatterTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSerializeInt32() {
        let testData: Int32 = 1234

        var expected = Int32(1234).littleEndian
        let actual = ZeroFormatter.serialize(testData)
        
        withUnsafeBytes(of: &expected) { (p1) in
            actual.withUnsafeBytes { (p2: UnsafePointer<UInt8>) in
                let ret = memcmp(p1.baseAddress!, p2, 4)
                XCTAssertEqual(ret, 0)
            }
        }
    }

    func testSerializeFixedSizeObject() {
        let testData = FixedSizeObject_2(a: 1234, b: 5678, c: 9012)
        
        let expexted: [UInt8] = [
            0x22, 0x00, 0x00, 0x00, // byteSize: 34
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x14, 0x00, 0x00, 0x00, // indexOffset[0]: 20
            0x18, 0x00, 0x00, 0x00, // indexOffset[1]: 24
            0x20, 0x00, 0x00, 0x00, // indexOffset[2]: 32
            0xd2, 0x04, 0x00, 0x00, // a: 1234
            0x2e, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // b: 5678
            0x34, 0x23 // c: 9012
        ]
        let actual = ZeroFormatter.serialize(testData)

        XCTAssertEqual(Array(actual), expexted)
    }
    
    func testDeserializeFixedSizeObject() {
        let testData: [UInt8] = [
            0x22, 0x00, 0x00, 0x00, // byteSize: 34
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x14, 0x00, 0x00, 0x00, // indexOffset[0]: 20
            0x18, 0x00, 0x00, 0x00, // indexOffset[1]: 24
            0x20, 0x00, 0x00, 0x00, // indexOffset[2]: 32
            0xd2, 0x04, 0x00, 0x00, // a: 1234
            0x2e, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // b: 5678
            0x34, 0x23 // c: 9012
        ]
        
        let expexted = FixedSizeObject_2(a: 1234, b: 5678, c: 9012)
        let actual: FixedSizeObject_2? = ZeroFormatter.deserialize(Data(bytes: testData))
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!.a, expexted.a)
        XCTAssertEqual(actual!.b, expexted.b)
        XCTAssertEqual(actual!.c, expexted.c)
    }
    
    func testSerializeFixedSizeStruct() {
        let testData = FixedSizeStruct(a: 250, b: 500, c: 1000)
        
        let expexted: [UInt8] = [
            0xfa, // UInt8 = 250
            0xf4, 0x01, 0x00, 0x00, // Int32 = 500
            0xe8, 0x03 // UInt16 = 1000
        ]
        let actual = ZeroFormatter.serialize(testData)
        
        XCTAssertEqual(Array(actual), expexted)
    }
    
    func testDeserializeFixedSizeStruct() {
        let testData: [UInt8] = [
            0xfa, // UInt8 = 250
            0xf4, 0x01, 0x00, 0x00, // Int32 = 500
            0xe8, 0x03 // UInt16 = 1000
        ]
        
        let expexted = FixedSizeStruct(a: 250, b: 500, c: 1000)
        let actual: FixedSizeStruct = ZeroFormatter.deserialize(Data(bytes: testData))
        
        XCTAssertEqual(actual.a, expexted.a)
        XCTAssertEqual(actual.b, expexted.b)
        XCTAssertEqual(actual.c, expexted.c)
    }
    
    func testDeserializeObjectInStruct() {
        let testData: [UInt8] = [
            0x57, 0x04, 0x00, 0x00, // x: 1111
            
            // y:
            0x22, 0x00, 0x00, 0x00, // byteSize: 34
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x18, 0x00, 0x00, 0x00, // indexOffset[0]: 24
            0x1c, 0x00, 0x00, 0x00, // indexOffset[1]: 28
            0x24, 0x00, 0x00, 0x00, // indexOffset[2]: 36
            0xd2, 0x04, 0x00, 0x00, // a: 1234
            0x2e, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // b: 5678
            0x34, 0x23, // c: 9012
            
            0x58, 0x04, 0x00, 0x00 // z: 1112
        ]
        
        let expexted = FixedSizeStruct_2(
            x: 1111,
            y: FixedSizeObject_2(a: 1234, b: 5678, c: 9012),
            z: 1112
        )
        let actual: FixedSizeStruct_2? = ZeroFormatter.deserialize(Data(bytes: testData))
        
        XCTAssertNotNil(actual)
        XCTAssertNotNil(actual!.y)
        XCTAssertEqual(actual!.x, expexted.x)
        XCTAssertEqual(actual!.y!.a, expexted.y!.a)
        XCTAssertEqual(actual!.y!.b, expexted.y!.b)
        XCTAssertEqual(actual!.y!.c, expexted.y!.c)
        XCTAssertEqual(actual!.z, expexted.z)
    }
    
}
