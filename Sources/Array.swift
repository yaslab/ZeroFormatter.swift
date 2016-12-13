//
//  Array.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum ArraySerializer {

    public static func serialize<T: Serializable>(_ bytes: NSMutableData, _ offset: Int, _ value: Array<T>?) -> Int {
        var byteSize = 4
        if let value = value {
            _serialize(bytes, Int32(value.count)) // length
            for v in value {
                byteSize += T.serialize(bytes, -1, v)
            }
        } else {
            _serialize(bytes, Int32(-1).littleEndian)
        }
        return byteSize
    }

    public static func serialize<T: Serializable>(_ bytes: NSMutableData, _ offset: Int, _ value: Array<Array<T>>?) -> Int {
        var byteSize = 4
        if let value = value {
            _serialize(bytes, Int32(value.count)) // length
            for v in value {
                byteSize += serialize(bytes, -1, v)
            }
        } else {
            _serialize(bytes, Int32(-1).littleEndian)
        }
        return byteSize
    }

}
