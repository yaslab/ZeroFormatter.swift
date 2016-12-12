//
//  Models.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/10.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import ZeroFormatter

struct VariableSizeObject: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16
    
    static var length: Int? {
        return nil
    }
    
    static func serialize(_ obj: VariableSizeObject, _ builder: ObjectBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
        builder.append(obj.c)
    }
    
    static func deserialize(_ extractor: ObjectExtractor) -> VariableSizeObject {
        return VariableSizeObject(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct VariableSizeStruct: StructSerializable, StructDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16
    
    static var length: Int? {
        return nil
    }
    
    static func serialize(_ obj: VariableSizeStruct, _ builder: StructBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
        builder.append(obj.c)
    }
    
    static func deserialize(_ extractor: StructExtractor) -> VariableSizeStruct {
        return VariableSizeStruct(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct FixedSizeObject: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: UInt8
    let c: Int16
    
    static var length: Int? {
        return _fixedSize([Int32.self, UInt8.self, Int16.self])
    }
    
    static func serialize(_ obj: FixedSizeObject, _ builder: ObjectBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
        builder.append(obj.c)
    }
    
    static func deserialize(_ extractor: ObjectExtractor) -> FixedSizeObject {
        return FixedSizeObject(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct FixedSizeObject_2: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: Int64
    let c: Int16
    
    static var length: Int? {
        return _fixedSize([Int32.self, Int64.self, Int16.self])
    }
    
    static func serialize(_ obj: FixedSizeObject_2, _ builder: ObjectBuilder) {
        // Index(0)
        builder.append(obj.a)
        // Index(1)
        builder.append(obj.b)
        // Index(2)
        builder.append(obj.c)
    }
    
    static func deserialize(_ extractor: ObjectExtractor) -> FixedSizeObject_2 {
        return FixedSizeObject_2(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct FixedSizeStruct: StructSerializable, StructDeserializable {
    
    let a: UInt8
    let b: Int32
    let c: UInt16
    
    static var length: Int? {
        return _fixedSize([UInt8.self, Int32.self, UInt16.self])
    }
    
    static func serialize(_ obj: FixedSizeStruct, _ builder: StructBuilder) {
        // Index(0)
        builder.append(obj.a)
        // Index(1)
        builder.append(obj.b)
        // Index(2)
        builder.append(obj.c)
    }
    
    static func deserialize(_ extractor: StructExtractor) -> FixedSizeStruct {
        return FixedSizeStruct(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}

struct FixedSizeStruct_2: StructSerializable, StructDeserializable {
    
    let x: UInt32
    let y: FixedSizeObject_2?
    let z: UInt32
    
    static var length: Int? {
        return _fixedSize([UInt32.self, FixedSizeObject_2.self, UInt32.self])
    }
    
    static func serialize(_ obj: FixedSizeStruct_2, _ builder: StructBuilder) {
        // Index(0)
        builder.append(obj.x)
        // Index(1)
        builder.append(obj.y)
        // Index(2)
        builder.append(obj.z)
    }
    
    static func deserialize(_ extractor: StructExtractor) -> FixedSizeStruct_2 {
        return FixedSizeStruct_2(
            x: extractor.extract(index: 0),
            y: extractor.extract(index: 1),
            z: extractor.extract(index: 2)
        )
    }
    
}
