//
//  Models.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/10.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation
import ZeroFormatter

struct MyObject: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16
    
    static var fixedSize: Int? {
        return nil
    }
    
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

struct MyStruct: StructSerializable, StructDeserializable {
    
    let a: Int32
    let b: String
    let c: Int16
    
    static var fixedSize: Int? {
        return nil
    }
    
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

struct FixedSizeObject: ObjectSerializable, ObjectDeserializable {
    
    let a: Int32
    let b: UInt8
    let c: Int16
    
    static var fixedSize: Int? {
        return 4 + 1 + 2
    }
    
    static func serialize(obj: FixedSizeObject, builder: ObjectBuilder) {
        builder.append(obj.a)
        builder.append(obj.b)
        builder.append(obj.c)
    }
    
    static func deserialize(extractor: ObjectExtractor) -> FixedSizeObject {
        return FixedSizeObject(
            a: extractor.extract(index: 0),
            b: extractor.extract(index: 1),
            c: extractor.extract(index: 2)
        )
    }
    
}
