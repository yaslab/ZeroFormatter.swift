//
//  ZeroFormatterSerializer.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class ZeroFormatterSerializer {
    
    private init() {}

    // MARK: - PrimitiveSerializable
    
    public static func serialize<T: PrimitiveSerializable>(_ value: T) -> Data {
        let data = NSMutableData()
        T.serialize(data, value)
        return data as Data
    }
    
    public static func serialize<T: PrimitiveSerializable>(_ value: T?) -> Data {
        let data = NSMutableData()
        T.serialize(data, value)
        return data as Data
    }
    
    // MARK: - Array of PrimitiveSerializable
    
    public static func serialize<T: PrimitiveSerializable>(_ values: Array<T>) -> Data {
        let data = NSMutableData()
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            T.serialize(data, value)
        }
        return data as Data
    }
    
    public static func serialize<T: PrimitiveSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        if let values = values {
            _serialize(data, Int32(values.count).littleEndian)
            for value in values {
                T.serialize(data, value)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        return data as Data
    }
    
    // MARK: - ObjectSerializable
    
    public static func serialize<T: ObjectSerializable>(_ value: T) -> Data {
        let data = NSMutableData()
        let builder = ObjectBuilder(data)
        T.serialize(obj: value, builder: builder)
        builder.build()
        return data as Data
    }
    
    public static func serialize<T: ObjectSerializable>(_ value: T?) -> Data {
        let data = NSMutableData()
        if let value = value {
            let builder = ObjectBuilder(data)
            T.serialize(obj: value, builder: builder)
            builder.build()
        } else {
            _serialize(data, Int32(-1))
        }
        return data as Data
    }
    
    // MARK: - Array of ObjectSerializable
    
    // TODO: ...
    
    // MARK: - ObjectDeserializable
    
    public static func serialize<T: StructSerializable>(_ value: T) -> Data {
        let data = NSMutableData()
        let builder = StructBuilder(data)
        T.serialize(obj: value, builder: builder)
        return data as Data
    }
    
    public static func serialize<T: StructSerializable>(_ value: T?) -> Data {
        let data = NSMutableData()
        if let value = value {
            _serialize(data, UInt8(1)) // hasValue
            let builder = StructBuilder(data)
            T.serialize(obj: value, builder: builder)
        } else {
            _serialize(data, UInt8(0)) // hasValue
        }
        return data as Data
    }
    
    // MARK: - PrimitiveDeserializable
    
    public static func deserialize<T: PrimitiveDeserializable>(_ data: Data) -> T {
        return T.deserialize(data, 0)
    }
    
    public static func deserialize<T: PrimitiveDeserializable>(_ data: Data) -> T? {
        return T.deserialize(data, 0)
    }
    
    // MARK: - ObjectDeserializable

    public static func deserialize<T: ObjectDeserializable>(_ data: Data) -> T? {
        let extractor = ObjectExtractor(data, 0)
        if extractor.isNil {
            return nil
        }
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }
    
    // MARK: - StructDeserializable
    
    public static func deserialize<T: StructDeserializable>(_ data: Data) -> T {
        let extractor = StructExtractor(data, 0)
        return T.deserialize(extractor: extractor)
    }
    
    public static func deserialize<T: StructDeserializable>(_ data: Data) -> T? {
        let extractor = StructExtractor(data, 0)
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }
    
}
