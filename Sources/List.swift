//
//  List.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/04.
//  Copyright © 2016年 yaslab. All rights reserved.
//

import Foundation

/* abstract */ class List<T>: RandomAccessCollection {
    
    let _originalData: Data
    let _offset: Int
    
    let _count: Int
    
    init(data: Data, offset: Int, count: Int) {
        _originalData = data
        _offset = offset
        _count = count
    }
    
    // MARK: - RandomAccessCollection
    
    var startIndex: Int {
        return 0
    }
    
    var endIndex: Int {
        return _count
    }
    
    func index(before i: Int) -> Int {
        return i - 1
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(index: Int) -> T {
        preconditionFailure()
    }
    
    // ...
    
    static func deserialize<U: PrimitiveDeserializable>(data: Data, offset: Int) -> List<U> {
        if let itemSize = U.fixedSize {
            return PrimitiveFixedSizeList<U>(data: data, offset: offset, itemSize: itemSize)
        } else {
            return PrimitiveVariableSizeList<U>(data: data, offset: offset)
        }
    }
    
    static func deserialize<U: ObjectDeserializable>(data: Data, offset: Int) -> List<U> {
        if let itemSize = U.fixedSize {
            return ObjectFixedSizeList<U>(data: data, offset: offset, itemSize: itemSize)
        } else {
            return ObjectVariableSizeList<U>(data: data, offset: offset)
        }
    }
    
    static func deserialize<U: StructDeserializable>(data: Data, offset: Int) -> List<U> {
        if let itemSize = U.fixedSize {
            return StructFixedSizeList<U>(data: data, offset: offset, itemSize: itemSize)
        } else {
            return StructVariableSizeList<U>(data: data, offset: offset)
        }
    }
    
}

class PrimitiveFixedSizeList<T: PrimitiveDeserializable>: List<T> {
    
    let _itemSize: Int
    
    init(data: Data, offset: Int, itemSize: Int) {
        _itemSize = itemSize
        let length: Int32 = _deserialize(data, offset)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset = _offset + 4 + (_itemSize * index)
        var size = 0
        return T.deserialize(_originalData, itemOffset, &size)
    }
    
}

class PrimitiveVariableSizeList<T: PrimitiveDeserializable>: List<T> {
    
    let _byteSize: Int
    
    init(data: Data, offset: Int) {
        let byteSize: Int32 = _deserialize(data, offset)
        _byteSize = Int(byteSize)
        let length: Int32 = _deserialize(data, offset + 4)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset: Int32 = _deserialize(_originalData, _offset + 4 + 4 + (4 * index))
        var size = 0
        return T.deserialize(_originalData, Int(itemOffset), &size)
    }
    
}

class ObjectFixedSizeList<T: ObjectDeserializable>: List<T> {
    
    let _itemSize: Int
    
    init(data: Data, offset: Int, itemSize: Int) {
        _itemSize = itemSize
        let length: Int32 = _deserialize(data, offset)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset = _offset + 4 + (_itemSize * index)
        let extractor = ObjectExtractor(_originalData, itemOffset)
        return T.deserialize(extractor: extractor)
    }
    
}

class ObjectVariableSizeList<T: ObjectDeserializable>: List<T> {
    
    let _byteSize: Int
    
    init(data: Data, offset: Int) {
        let byteSize: Int32 = _deserialize(data, offset)
        _byteSize = Int(byteSize)
        let length: Int32 = _deserialize(data, offset + 4)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset: Int32 = _deserialize(_originalData, _offset + 4 + 4 + (4 * index))
        let extractor = ObjectExtractor(_originalData, Int(itemOffset))
        return T.deserialize(extractor: extractor)
    }
    
}

class StructFixedSizeList<T: StructDeserializable>: List<T> {
    
    let _itemSize: Int
    
    init(data: Data, offset: Int, itemSize: Int) {
        _itemSize = itemSize
        let length: Int32 = _deserialize(data, offset)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset = _offset + 4 + (_itemSize * index)
        let extractor = StructExtractor(_originalData, itemOffset)
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }
    
}

class StructVariableSizeList<T: StructDeserializable>: List<T> {
    
    let _byteSize: Int
    
    init(data: Data, offset: Int) {
        let byteSize: Int32 = _deserialize(data, offset)
        _byteSize = Int(byteSize)
        let length: Int32 = _deserialize(data, offset + 4)
        super.init(data: data, offset: offset, count: Int(length))
    }
    
    // TODO: save to memory cache
    override subscript(index: Int) -> T {
        let itemOffset: Int32 = _deserialize(_originalData, _offset + 4 + 4 + (4 * index))
        let extractor = StructExtractor(_originalData, Int(itemOffset))
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }
    
}
