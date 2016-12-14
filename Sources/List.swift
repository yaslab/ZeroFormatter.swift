//
//  List.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/04.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum ListSerializer {
    
    static func serialize<T: Serializable>(_ data: NSMutableData, _ values: List<T>?) -> Int {
        if let values = values {
            let offset = data.length
            var byteSize = 0
            
            if let _ = T.length {
                byteSize += BinaryUtility.serialize(data, values.count) // length
            } else {
                byteSize += BinaryUtility.serialize(data, 0) // byteSize
                byteSize += BinaryUtility.serialize(data, values.count) // length
                for _ in 0 ..< values.count {
                    byteSize += BinaryUtility.serialize(data, 0) // elementOffset
                }
            }
            
            for i in 0 ..< values.count {
                if T.length == nil {
                    // elementOffse
                    _ = BinaryUtility.serialize(data, offset + 4 + 4 + (4 * i), data.length)
                }
                byteSize += T.serialize(data, -1, values[i])
            }
            
            if T.length == nil {
                // byteSize
                _ = BinaryUtility.serialize(data, offset, byteSize)
            }
            
            return byteSize
        } else {
            return BinaryUtility.serialize(data, -1) // length
        }
    }

    static func serializeAsList<T: Serializable>(_ data: NSMutableData, _ values: Array<T>?) -> Int {
        if let values = values {
            let offset = data.length
            var byteSize = 0
            
            if T.length != nil {
                byteSize += BinaryUtility.serialize(data, values.count) // length
            } else {
                byteSize += BinaryUtility.serialize(data, 0) // byteSize
                byteSize += BinaryUtility.serialize(data, values.count) // length
                for _ in 0 ..< values.count {
                    byteSize += BinaryUtility.serialize(data, 0) // elementOffset
                }
            }
            
            for i in 0 ..< values.count {
                if T.length == nil {
                    // elementOffset
                    _ = BinaryUtility.serialize(data, offset + 4 + 4 + (4 * i), data.length)
                }
                byteSize += T.serialize(data, -1, values[i])
            }
            
            if T.length == nil {
                // byteSize
                _ = BinaryUtility.serialize(data, offset, byteSize)
            }
            
            return byteSize
        } else {
            return BinaryUtility.serialize(data, -1) // length
        }
    }

}

public class List<T>: RandomAccessCollection {
    
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
        var tmp = 0
        let length: Int = BinaryUtility.deserialize(data, offset, &tmp)
        if length < 0 {
            return nil
        }
        super.init(data: data, offset: offset, count: length)
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
        var currentOffset = offset
        let byteSize: Int = BinaryUtility.deserialize(data, currentOffset, &currentOffset)
        if byteSize < 0 {
            return nil
        }
        _byteSize = byteSize
        let length: Int = BinaryUtility.deserialize(data, currentOffset, &currentOffset)
        super.init(data: data, offset: offset, count: length)
    }
    
    // TODO: save to memory cache
    override public subscript(index: Int) -> T {
        var tmp = 0
        let itemOffset: Int = BinaryUtility.deserialize(_originalData, _offset + 4 + 4 + (4 * index), &tmp)
        return T.deserialize(_originalData, itemOffset, &tmp)
    }
    
}
