//
//  List.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/04.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

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
