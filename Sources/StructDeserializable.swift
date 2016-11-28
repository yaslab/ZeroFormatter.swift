//
//  StructDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol StructDeserializable {
    static func deserialize(extractor: StructExtractor) -> Self
}

public class StructExtractor {
    
    private let data: Data
    private let offset: Int
    private var currentOffset: Int
    
    var size: Int {
        return currentOffset - offset
    }
    
    internal init(_ data: Data, _ offset: Int) {
        self.data = data
        self.offset = offset
        self.currentOffset = offset
    }
    
    // -----
    
    public func extract<T: PrimitiveDeserializable>(index: Int) -> T {
        var size = 0
        let value: T = T.deserialize(data, currentOffset, &size)
        currentOffset += size
        return value
    }
    
    public func extract<T: PrimitiveDeserializable>(index: Int) -> T? {
        var size = 0
        let value: T? = T.deserialize(data, currentOffset, &size)
        currentOffset += size
        return value
    }
    
    public func extract<T: PrimitiveDeserializable>(index: Int) -> Array<T>? {
        let length: Int32 = _deserialize(data, currentOffset)
        currentOffset += 4
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        for _ in 0 ..< length {
            var size = 0
            array.append(T.deserialize(data, currentOffset, &size))
            currentOffset += size
        }
        return array
    }
    
    // -----
    
    public func extract<T: ObjectDeserializable>(index: Int) -> T? {
        let extractor = ObjectExtractor(data, currentOffset)
        if extractor.isNil {
            return nil
        }
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    public func extract<T: ObjectDeserializable>(index: Int) -> Array<T>? {
        let length: Int32 = _deserialize(data, currentOffset)
        currentOffset += 4
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        for _ in 0 ..< length {
            let extractor = ObjectExtractor(data, currentOffset)
            let obj: T? = T.deserialize(extractor: extractor)
            array.append(obj!)
            currentOffset += extractor.size
        }
        return array
    }
    
    // -----
    
    public func extract<T: StructDeserializable>(index: Int) -> T {
        let extractor = StructExtractor(data, currentOffset)
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    public func extract<T: StructDeserializable>(index: Int) -> T? {
        let hasValue: UInt8 = _deserialize(data, currentOffset)
        currentOffset += 1
        if hasValue == 0 {
            return nil
        }
        let extractor = StructExtractor(data, currentOffset)
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    public func extract<T: StructDeserializable>(index: Int) -> Array<T>? {
        let length: Int32 = _deserialize(data, currentOffset)
        currentOffset += 4
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        for _ in 0 ..< length {
            let extractor = StructExtractor(data, currentOffset)
            array.append(T.deserialize(extractor: extractor))
            currentOffset += extractor.size
        }
        return array
    }
    
}
