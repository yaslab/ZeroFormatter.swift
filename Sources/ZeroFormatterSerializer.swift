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
    
    static func serialize<T: PrimitiveSerializable>(_ value: T) -> Data {
        var data = Data()
        T.serialize(&data, value)
        return data
    }
    
    static func serialize<T: PrimitiveSerializable>(_ value: T?) -> Data {
        var data = Data()
        T.serialize(&data, value)
        return data
    }
    
    // MARK: - Array of PrimitiveSerializable
    
    static func serialize<T: PrimitiveSerializable>(_ values: Array<T>) -> Data {
        var data = Data()
        _serialize(&data, Int32(values.count).littleEndian)
        for value in values {
            T.serialize(&data, value)
        }
        return data
    }
    
    static func serialize<T: PrimitiveSerializable>(_ values: Array<T>?) -> Data {
        var data = Data()
        if let values = values {
            _serialize(&data, Int32(values.count).littleEndian)
            for value in values {
                T.serialize(&data, value)
            }
        } else {
            _serialize(&data, Int32(-1).littleEndian)
        }
        return data
    }
    
    // MARK: - ObjectSerializable
    
    static func serialize<T: ObjectSerializable>(_ value: T) -> Data {
        var data = Data()
        let builder = ObjectBuilder(&data)
        T.serialize(obj: value, builder: builder)
        builder.build()
        return data
    }
    
    static func serialize<T: ObjectSerializable>(_ value: T?) -> Data {
        var data = Data()
        if let value = value {
            let builder = ObjectBuilder(&data)
            T.serialize(obj: value, builder: builder)
            builder.build()
        } else {
            _serialize(&data, Int32(-1))
        }
        return data
    }
    
    // MARK: - Array of ObjectSerializable
    
    // TODO: ...
    
}
