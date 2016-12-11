//
//  Array.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016年 yaslab. All rights reserved.
//

import Foundation

class ArraySerializer {
    
    static func serialize<T: PrimitiveSerializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        
        var byteSize = 4
        
        if let values = values {
            _serialize(data, Int32(values.count)) // length
            for value in values {
                byteSize += T.serialize(data, value)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }
    
    static func serialize<T: ObjectSerializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        
        var byteSize = 4
        
        if let values = values {
            _serialize(data, Int32(values.count)) // length
            for value in values {
                let builder = ObjectBuilder(data)
                T.serialize(obj: value, builder: builder)
                byteSize += builder.build()
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }
    
    static func serialize<T: StructSerializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        
        var byteSize = 4
        
        if let values = values {
            _serialize(data, Int32(values.count)) // length
            for value in values {
                let builder = StructBuilder(data)
                T.serialize(obj: value, builder: builder)
                byteSize += builder.currentSize
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }
    
    // Arran in Array
    
    static func serialize<T: PrimitiveSerializable>(_ data: NSMutableData, _ values: Array<Array<T>>?) -> Int {
        // TODO: add header
        if let values = values {
            var byteSize = 0
            for value in values {
                byteSize += serialize(data, value)
            }
            return byteSize
        } else {
            // TODO: nil
            return -1
        }
    }
    
    static func serialize<T: ObjectSerializable>(_ data: NSMutableData, _ values: Array<Array<T>>?) -> Int {
        // TODO: add header
        if let values = values {
            var byteSize = 0
            for value in values {
                byteSize += serialize(data, value)
            }
            return byteSize
        } else {
            // TODO: nil
            return -1
        }
    }
    
    static func serialize<T: StructSerializable>(_ data: NSMutableData, _ values: Array<Array<T>>?) -> Int {
        // TODO: add header
        if let values = values {
            var byteSize = 0
            for value in values {
                byteSize += serialize(data, value)
            }
            return byteSize
        } else {
            // TODO: nil
            return -1
        }
    }
    
}
