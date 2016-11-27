//
//  StructDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016年 yaslab. All rights reserved.
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
    
    internal func extract<T: PrimitiveDeserializable>(index: Int) -> T {
        defer {
            currentOffset += MemoryLayout<T>.size
        }
        return T.deserialize(data, currentOffset)
    }
    
    internal func extract<T: PrimitiveDeserializable>(index: Int) -> T? {
        defer {
            currentOffset += MemoryLayout<T>.size + 1
        }
        return T.deserialize(data, currentOffset)
    }
    
    // -----
    
    internal func extract<T: ObjectDeserializable>(index: Int) -> T {
        let extractor = ObjectExtractor(data, currentOffset)
        if extractor.isNil {
            // TODO: throw error
        }
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    internal func extract<T: ObjectDeserializable>(index: Int) -> T? {
        let extractor = ObjectExtractor(data, currentOffset)
        if extractor.isNil {
            return nil
        }
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    // -----
    
    internal func extract<T: StructDeserializable>(index: Int) -> T {
        let extractor = StructExtractor(data, currentOffset)
        let obj: T = T.deserialize(extractor: extractor)
        currentOffset += extractor.size
        return obj
    }
    
    internal func extract<T: StructDeserializable>(index: Int) -> T? {
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
    
}
