//
//  ZeroFormatterTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/26.
//  Copyright © 2016 yaslab. All rights reserved.
//

import XCTest
@testable import ZeroFormatter

struct MyObject: ObjectSerializable, ObjectDeserializable {

    let a: Int32
    let b: Int64
    let c: Int16
    
    static func serialize(obj: MyObject, builder: ObjectBuilder) {
        // Index(0)
        builder.append(obj.a)
        // Index(1)
        builder.append(obj.b)
        // Index(2)
        builder.append(obj.c)
    }

    static func deserialize(extractor: ObjectExtractor) -> MyObject {
        return MyObject(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct MyStruct: StructSerializable {
    
    let a: UInt8
    let b: Int32
    let c: UInt16

    static func serialize(obj: MyStruct, builder: StructBuilder) {
        // Index(0)
        builder.append(obj.a)
        // Index(1)
        builder.append(obj.b)
        // Index(2)
        builder.append(obj.c)
    }
    
}

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
        let actual = ZeroFormatterSerializer.serialize(testData)
        
        withUnsafeBytes(of: &expected) { (p1) in
            actual.withUnsafeBytes { (p2: UnsafePointer<UInt8>) in
                let ret = memcmp(p1.baseAddress!, p2, 4)
                XCTAssertEqual(ret, 0)
            }
        }
    }

    func testSerializeMyObject() {
        let testData = MyObject(a: 1234, b: 5678, c: 9012)
        
        let expexted: [UInt8] = [
            0x22, 0x00, 0x00, 0x00, // byteSize: 34
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x14, 0x00, 0x00, 0x00, // indexOffset[0]: 20
            0x18, 0x00, 0x00, 0x00, // indexOffset[1]: 24
            0x20, 0x00, 0x00, 0x00, // indexOffset[2]: 32
            0xd2, 0x04, 0x00, 0x00, // 1234
            0x2e, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 5678
            0x34, 0x23 // 9012
        ]
        let actual = ZeroFormatterSerializer.serialize(testData)

        XCTAssertEqual(Array(actual), expexted)
    }
    
    func testDeserializeMyObject() {
        let testData: [UInt8] = [
            0x22, 0x00, 0x00, 0x00, // byteSize: 34
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x14, 0x00, 0x00, 0x00, // indexOffset[0]: 20
            0x18, 0x00, 0x00, 0x00, // indexOffset[1]: 24
            0x20, 0x00, 0x00, 0x00, // indexOffset[2]: 32
            0xd2, 0x04, 0x00, 0x00, // 1234
            0x2e, 0x16, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 5678
            0x34, 0x23 // 9012
        ]
        
        let expexted = MyObject(a: 1234, b: 5678, c: 9012)
        let actual: MyObject = ZeroFormatterSerializer.deserialize(Data(bytes: testData))

        XCTAssertEqual(actual.a, expexted.a)
        XCTAssertEqual(actual.b, expexted.b)
        XCTAssertEqual(actual.c, expexted.c)
    }
    
    func testSerializeMyStruct() {
        let testData = MyStruct(a: 250, b: 500, c: 1000)
        
        let expexted: [UInt8] = [
            0xfa, // UInt8 = 250
            0xf4, 0x01, 0x00, 0x00, // Int32 = 500
            0xe8, 0x03 // UInt16 = 1000
        ]
        let actual = ZeroFormatterSerializer.serialize(testData)
        
        XCTAssertEqual(Array(actual), expexted)
    }
    
}
