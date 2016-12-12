//
//  List.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/04.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

class ListSerializer {
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

public /* abstract */ class List<T>: RandomAccessCollection {
    
    let _originalData: NSData
    let _offset: Int
    
    let _count: Int
    
    init?(data: NSData, offset: Int, count: Int) {
        _originalData = data
        _offset = offset
        _count = count
    }
    
    // MARK: - RandomAccessCollection
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return _count
    }
    
    public func index(before i: Int) -> Int {
        return i - 1
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript(index: Int) -> T {
        preconditionFailure()
    }

}

public class FixedSizeList<T: Deserializable>: List<T> {
    
    let _itemSize: Int
    
    init?(data: NSData, offset: Int, itemSize: Int) {
        _itemSize = itemSize
        let length: Int32 = _deserialize(data, offset)
        if length < 0 {
            return nil
        }
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override public subscript(index: Int) -> T {
        let itemOffset = _offset + 4 + (_itemSize * index)
        var size = 0
        return T.deserialize(_originalData, itemOffset, &size)
    }
    
}

public class VariableSizeList<T: Deserializable>: List<T> {
    
    let _byteSize: Int
    
    init?(data: NSData, offset: Int) {
        let byteSize: Int32 = _deserialize(data, offset)
        if byteSize < 0 {
            return nil
        }
        _byteSize = Int(byteSize)
        let length: Int32 = _deserialize(data, offset + 4)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override public subscript(index: Int) -> T {
        let itemOffset: Int32 = _deserialize(_originalData, _offset + 4 + 4 + (4 * index))
        var size = 0
        return T.deserialize(_originalData, Int(itemOffset), &size)
    }
    
}
