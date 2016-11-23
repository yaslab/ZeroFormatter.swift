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
    
}
