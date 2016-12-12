//
//  Array.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

class ArraySerializer {
    
    static func serialize<T: Serializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        var byteSize = 4
        
        if let values = values {
            _serialize(data, Int32(values.count)) // length
            for value in values {
                byteSize += T.serialize(data, 0, value)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }
    
    static func serialize<T: Serializable>(_ data: NSMutableData, _ values: Array<Array<T>>?) -> Int {
        var byteSize = 4
        
        if let values = values {
            _serialize(data, Int32(values.count)) // length
            for value in values {
                byteSize += serialize(data, value)
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }

}
