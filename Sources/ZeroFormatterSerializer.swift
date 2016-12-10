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

}

extension ZeroFormatterSerializer {

    // MARK: - PrimitiveSerializable
    
    public static func serialize<T: PrimitiveSerializable>(_ value: T) -> Data {
        let data = NSMutableData()
        _ = T.serialize(data, value)
        return data as Data
    }
    
    public static func serialize<T: PrimitiveSerializable>(_ value: T?) -> Data {
        let data = NSMutableData()
        _ = T.serialize(data, value)
        return data as Data
    }
    
    // MARK: - Array of PrimitiveSerializable
    
    public static func serialize<T: PrimitiveSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        if let values = values {
            _serialize(data, Int32(values.count).littleEndian)
            for value in values {
                _ = T.serialize(data, value)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        return data as Data
    }
    
    // MARK: - ObjectSerializable
    
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
    
    public static func serialize<T: ObjectSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        if let values = values {
            _serialize(data, Int32(values.count).littleEndian)
            for value in values {
                let builder = ObjectBuilder(data)
                T.serialize(obj: value, builder: builder)
                builder.build()
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        return data as Data
    }
    
    // MARK: - StructSerializable
    
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
    
    // MARK: - Array of StructSerializable
    
    public static func serialize<T: StructSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        if let values = values {
            _serialize(data, Int32(values.count).littleEndian)
            for value in values {
                let builder = StructBuilder(data)
                T.serialize(obj: value, builder: builder)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        return data as Data
    }
    
    // MARK: - List
    
    public static func serializeAsList<T: PrimitiveSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        _ = ListSerializer.serializeAsList(data, values)
        return data as Data
    }

    public static func serializeAsList<T: ObjectSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        _ = ListSerializer.serializeAsList(data, values)
        return data as Data
    }
    
    public static func serializeAsList<T: StructSerializable>(_ values: Array<T>?) -> Data {
        let data = NSMutableData()
        _ = ListSerializer.serializeAsList(data, values)
        return data as Data
    }
    
}

extension ZeroFormatterSerializer {
    
    // MARK: - PrimitiveDeserializable
    
    public static func deserialize<T: PrimitiveDeserializable>(_ data: Data) -> T {
        var size = 0
        return T.deserialize(data, 0, &size)
    }
    
    public static func deserialize<T: PrimitiveDeserializable>(_ data: Data) -> T? {
        var size = 0
        return T.deserialize(data, 0, &size)
    }
    
    // MARK: - Array of PrimitiveDeserializable
    
    public static func deserialize<T: PrimitiveDeserializable>(_ data: Data) -> Array<T>? {
        let length: Int32 = _deserialize(data, 0)
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var offset = 4
        for _ in 0 ..< length {
            var size = 0
            array.append(T.deserialize(data, offset, &size))
            offset += size
        }
        return array
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
    
    // MARK: - Array of ObjectDeserializable
    
    public static func deserialize<T: ObjectDeserializable>(_ data: Data) -> Array<T>? {
        let length: Int32 = _deserialize(data, 0)
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var offset = 4
        for _ in 0 ..< length {
            let extractor = ObjectExtractor(data, offset)
            array.append(T.deserialize(extractor: extractor))
            offset += extractor.size
        }
        return array
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

    // MARK: - Array of StructDeserializable
    
    public static func deserialize<T: StructDeserializable>(_ data: Data) -> Array<T>? {
        let length: Int32 = _deserialize(data, 0)
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var offset = 4
        for _ in 0 ..< length {
            let extractor = StructExtractor(data, offset)
            array.append(T.deserialize(extractor: extractor))
            offset += extractor.size
        }
        return array
    }
    
    // MARK: - List
    
    public static func deserializeAsList<T: PrimitiveDeserializable>(_ data: Data) -> List<T>? {
        return ListSerializer.deserialize(data: data, offset: 0)
    }
    
    public static func deserializeAsList<T: ObjectDeserializable>(_ data: Data) -> List<T>? {
        return ListSerializer.deserialize(data: data, offset: 0)
    }
    
    public static func deserializeAsList<T: StructDeserializable>(_ data: Data) -> List<T>? {
        return ListSerializer.deserialize(data: data, offset: 0)
    }
    
}
