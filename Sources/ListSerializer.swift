//
//  ListSerializer.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/13.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum ListSerializer {
    
    static func serialize<T: Serializable>(_ data: NSMutableData, _ values: List<T>?) -> Int {
        if let values = values {
            return __serialize(data, T.length, values.count) {
                return T.serialize(data, 0, values[$0])
            }
        } else {
            _serialize(data, Int32(-1).littleEndian)
            return 4
        }
    }
    
    static func __serialize(_ data: NSMutableData, _ fixedSize: Int?, _ count: Int, _ f: ((Int) -> Int)) -> Int {
        let offset = data.length
        var byteSize = 0
        
        if fixedSize != nil {
            let length = Int32(count)
            _serialize(data, length.littleEndian)
            
            byteSize += 4
        } else {
            let zero = Int32(0)
            _serialize(data, zero) // byteSize
            let length = Int32(count)
            _serialize(data, length.littleEndian)
            for _ in 0 ..< count {
                _serialize(data, zero) // elementOffset
            }
            
            byteSize += 4 + 4 + (4 * count)
        }
        
        for i in 0 ..< count {
            if fixedSize == nil {
                // elementOffset
                let p = data.mutableBytes + offset + 4 + 4 + (4 * i)
                p.assumingMemoryBound(to: Int32.self)[0] = Int32(data.length).littleEndian
            }
            byteSize += f(i)
        }
        
        if fixedSize == nil {
            // byteSize
            let p = data.mutableBytes + offset
            p.assumingMemoryBound(to: Int32.self)[0] = Int32(byteSize).littleEndian
        }
        
        return byteSize
    }
    
    static func serializeAsList<T: Serializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        if let values = values {
            return _serializeAsList(data, T.length, values.count) { T.serialize(data, 0, values[$0]) }
        } else {
            _serialize(data, Int32(-1).littleEndian)
            return 4
        }
    }
    
    private static func _serializeAsList(_ data: NSMutableData, _ fixedSize: Int?, _ count: Int, _ f: ((Int) -> Int)) -> Int {
        let offset = data.length
        var byteSize = 0
        
        if fixedSize != nil {
            let length = Int32(count)
            _serialize(data, length.littleEndian)
            
            byteSize += 4
        } else {
            let zero = Int32(0)
            _serialize(data, zero) // byteSize
            let length = Int32(count)
            _serialize(data, length.littleEndian)
            for _ in 0 ..< count {
                _serialize(data, zero) // elementOffset
            }
            
            byteSize += 4 + 4 + (4 * count)
        }
        
        for i in 0 ..< count {
            if fixedSize == nil {
                // elementOffset
                let p = data.mutableBytes + offset + 4 + 4 + (4 * i)
                p.assumingMemoryBound(to: Int32.self)[0] = Int32(data.length).littleEndian
            }
            byteSize += f(i)
        }
        
        if fixedSize == nil {
            // byteSize
            let p = data.mutableBytes + offset
            p.assumingMemoryBound(to: Int32.self)[0] = Int32(byteSize).littleEndian
        }
        
        return byteSize
    }
    
}
