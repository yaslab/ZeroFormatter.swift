//
//  ArrayTestCase.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/29.
//  Copyright © 2016 yaslab. All rights reserved.
//

import XCTest
import ZeroFormatter

private struct MyObject: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16

    static func serialize(obj: MyObject, builder: ObjectBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
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

private struct MyStruct: StructSerializable, StructDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16

    static func serialize(obj: MyStruct, builder: StructBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
        builder.append(obj.c)
    }
    
    static func deserialize(extractor: StructExtractor) -> MyStruct {
        return MyStruct(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

class ArrayTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - Serialize
    
    func testSerializePrimitiveArray() {
        let testData: [Int16] = [1, 2, 3, 4, 5]
        
        let expected: [UInt8] = [
            0x05, 0x00, 0x00, 0x00,
            0x01, 0x00,
            0x02, 0x00,
            0x03, 0x00,
            0x04, 0x00,
            0x05, 0x00
        ]
        let actual = ZeroFormatterSerializer.serialize(testData)
        
        XCTAssertEqual(Array(actual), expected)
    }

    func testSerializeObjectArray() {
        let testData: [MyObject] = [
            MyObject(a: 2, b: "01234", c: 3),
            MyObject(a: 4, b: "567890", c: 5)
        ]
        
        let expected: [UInt8] = [
            0x02, 0x00, 0x00, 0x00, // 2
            
            0x23, 0x00, 0x00, 0x00, // byteSize: 35
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x18, 0x00, 0x00, 0x00, // indexOffset[0]: 24
            0x1c, 0x00, 0x00, 0x00, // indexOffset[1]: 28
            0x25, 0x00, 0x00, 0x00, // indexOffset[2]: 37
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3
            
            0x24, 0x00, 0x00, 0x00, // byteSize: 36
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x3b, 0x00, 0x00, 0x00, // indexOffset[0]: 59
            0x3f, 0x00, 0x00, 0x00, // indexOffset[1]: 63
            0x49, 0x00, 0x00, 0x00, // indexOffset[2]: 73
            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        let actual = ZeroFormatterSerializer.serialize(testData)
        
        XCTAssertEqual(Array(actual), expected)
    }
    
    func testSerializeStructArray() {
        let testData: [MyStruct] = [
            MyStruct(a: 2, b: "01234", c: 3),
            MyStruct(a: 4, b: "567890", c: 5)
        ]
        
        let expected: [UInt8] = [
            0x02, 0x00, 0x00, 0x00, // 2
            
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3

            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        let actual = ZeroFormatterSerializer.serialize(testData)
        
        XCTAssertEqual(Array(actual), expected)
    }
    
    // MARK: - Deserialize
    
    func testDeserializePrimitiveArray() {
        let testData: [UInt8] = [
            0x05, 0x00, 0x00, 0x00,
            0x01, 0x00,
            0x02, 0x00,
            0x03, 0x00,
            0x04, 0x00,
            0x05, 0x00
        ]
        
        let expected: [Int16] = [1, 2, 3, 4, 5]
        let actual: [Int16]? = ZeroFormatterSerializer.deserialize(Data(bytes: testData))
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual!, expected)
    }
    
    func testDeserializeObjectArray() {
        let testData: [UInt8] = [
            0x02, 0x00, 0x00, 0x00, // 2
            
            0x23, 0x00, 0x00, 0x00, // byteSize: 35
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x18, 0x00, 0x00, 0x00, // indexOffset[0]: 24
            0x1c, 0x00, 0x00, 0x00, // indexOffset[1]: 28
            0x25, 0x00, 0x00, 0x00, // indexOffset[2]: 37
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3
            
            0x24, 0x00, 0x00, 0x00, // byteSize: 36
            0x02, 0x00, 0x00, 0x00, // lastIndex: 2
            0x3b, 0x00, 0x00, 0x00, // indexOffset[0]: 59
            0x3f, 0x00, 0x00, 0x00, // indexOffset[1]: 63
            0x49, 0x00, 0x00, 0x00, // indexOffset[2]: 73
            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        
        let expected: [MyObject] = [
            MyObject(a: 2, b: "01234", c: 3),
            MyObject(a: 4, b: "567890", c: 5)
        ]
        let actual: [MyObject]? = ZeroFormatterSerializer.deserialize(Data(bytes: testData))
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual![0].a, expected[0].a)
        XCTAssertEqual(actual![0].b, expected[0].b)
        XCTAssertEqual(actual![0].c, expected[0].c)
        XCTAssertEqual(actual![1].a, expected[1].a)
        XCTAssertEqual(actual![1].b, expected[1].b)
        XCTAssertEqual(actual![1].c, expected[1].c)
    }
    
    func testDeserializeStructArray() {
        let testData: [UInt8] = [
            0x02, 0x00, 0x00, 0x00, // 2
            
            0x02, 0x00, 0x00, 0x00, // a: 2
            0x05, 0x00, 0x00, 0x00, 0x30, 0x31, 0x32, 0x33, 0x34, // b: "01234"
            0x03, 0x00, // c: 3
            
            0x04, 0x00, 0x00, 0x00, // a: 4
            0x06, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x30, // b: "567890"
            0x05, 0x00 // c: 5
        ]
        
        let expected: [MyStruct] = [
            MyStruct(a: 2, b: "01234", c: 3),
            MyStruct(a: 4, b: "567890", c: 5)
        ]
        let actual: [MyStruct]? = ZeroFormatterSerializer.deserialize(Data(bytes: testData))
        
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual![0].a, expected[0].a)
        XCTAssertEqual(actual![0].b, expected[0].b)
        XCTAssertEqual(actual![0].c, expected[0].c)
        XCTAssertEqual(actual![1].a, expected[1].a)
        XCTAssertEqual(actual![1].b, expected[1].b)
        XCTAssertEqual(actual![1].c, expected[1].c)
    }
    
}
