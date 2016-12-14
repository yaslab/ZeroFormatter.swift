//
//  ArraySerializer.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum ArraySerializer {
    
    // MARK: - serialize

    public static func serialize<T: Serializable>(_ bytes: NSMutableData, _ offset: Int, _ value: Array<T>?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += BinaryUtility.serialize(bytes, value.count) // length
            for v in value {
                byteSize += T.serialize(bytes, -1, v)
            }
        } else {
            byteSize += BinaryUtility.serialize(bytes, -1) // length
        }
        return byteSize
    }

    public static func serialize<T: Serializable>(_ bytes: NSMutableData, _ offset: Int, _ value: Array<Array<T>>?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += BinaryUtility.serialize(bytes, value.count) // length
            for v in value {
                byteSize += serialize(bytes, -1, v)
            }
        } else {
            byteSize += BinaryUtility.serialize(bytes, -1) // length
        }
        return byteSize
    }

    // MARK: - deserialize
    
    public static func deserialize<T: Deserializable>(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Array<T>? {
        let start = byteSize
        let length: Int = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        for _ in 0 ..< length {
            array.append(T.deserialize(bytes, offset + (byteSize - start), &byteSize))
        }
        return array
    }
    
}
