//
//  List.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/04.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum ListSerializer {
    
    static func serialize<T: Serializable>(_ bytes: NSMutableData, _ values: List<T>?) -> Int {
        if let values = values {
            let offset = bytes.length
            var byteSize = 0
            
            if let _ = T.length {
                byteSize += BinaryUtility.serialize(bytes, values.count) // length
            } else {
                byteSize += BinaryUtility.serialize(bytes, 0) // byteSize
                byteSize += BinaryUtility.serialize(bytes, values.count) // length
                for _ in 0 ..< values.count {
                    byteSize += BinaryUtility.serialize(bytes, 0) // elementOffset
                }
            }
            
            for i in 0 ..< values.count {
                if T.length == nil {
                    // elementOffse
                    _ = BinaryUtility.serialize(bytes, offset + 4 + 4 + (4 * i), bytes.length)
                }
                byteSize += T.serialize(bytes, -1, values[i])
            }
            
            if T.length == nil {
                // byteSize
                _ = BinaryUtility.serialize(bytes, offset, byteSize)
            }
            
            return byteSize
        } else {
            return BinaryUtility.serialize(bytes, -1) // length
        }
    }

    static func serializeAsList<T: Serializable>(_ bytes: NSMutableData, _ values: Array<T>?) -> Int {
        if let values = values {
            let offset = bytes.length
            var byteSize = 0
            
            if T.length != nil {
                byteSize += BinaryUtility.serialize(bytes, values.count) // length
            } else {
                byteSize += BinaryUtility.serialize(bytes, 0) // byteSize
                byteSize += BinaryUtility.serialize(bytes, values.count) // length
                for _ in 0 ..< values.count {
                    byteSize += BinaryUtility.serialize(bytes, 0) // elementOffset
                }
            }
            
            for i in 0 ..< values.count {
                if T.length == nil {
                    // elementOffset
                    _ = BinaryUtility.serialize(bytes, offset + 4 + 4 + (4 * i), bytes.length)
                }
                byteSize += T.serialize(bytes, -1, values[i])
            }
            
            if T.length == nil {
                // byteSize
                _ = BinaryUtility.serialize(bytes, offset, byteSize)
            }
            
            return byteSize
        } else {
            return BinaryUtility.serialize(bytes, -1) // length
        }
    }

}

public class List<T>: RandomAccessCollection {
    
    let _originalBytes: NSData
    let _offset: Int
    
    let _count: Int
    
    init?(bytes: NSData, offset: Int, count: Int) {
        _originalBytes = bytes
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

public class FixedSizeList<T: Serializable>: List<T> {
    
    let _itemSize: Int
    
    init?(bytes: NSData, offset: Int, itemSize: Int) {
        _itemSize = itemSize
        var tmp = 0
        let length: Int = BinaryUtility.deserialize(bytes, offset, &tmp)
        if length < 0 {
            return nil
        }
        super.init(bytes: bytes, offset: offset, count: length)
    }
    
    // TODO: save to memory cache
    override public subscript(index: Int) -> T {
        let itemOffset = _offset + 4 + (_itemSize * index)
        var size = 0
        return T.deserialize(_originalBytes, itemOffset, &size)
    }
    
}

public class VariableSizeList<T: Serializable>: List<T> {
    
    let _byteSize: Int
    
    init?(bytes: NSData, offset: Int) {
        var currentOffset = offset
        let byteSize: Int = BinaryUtility.deserialize(bytes, currentOffset, &currentOffset)
        if byteSize < 0 {
            return nil
        }
        _byteSize = byteSize
        let length: Int = BinaryUtility.deserialize(bytes, currentOffset, &currentOffset)
        super.init(bytes: bytes, offset: offset, count: length)
    }
    
    // TODO: save to memory cache
    override public subscript(index: Int) -> T {
        var tmp = 0
        let itemOffset: Int = BinaryUtility.deserialize(_originalBytes, _offset + 4 + 4 + (4 * index), &tmp)
        return T.deserialize(_originalBytes, itemOffset, &tmp)
    }
    
}
