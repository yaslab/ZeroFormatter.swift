//
//  StructDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class StructExtractor {
    
    private let data: NSData
    private let offset: Int
    private var currentOffset: Int
    
    var byteSize: Int {
        return currentOffset - offset
    }
    
    internal init(_ data: NSData, _ offset: Int) {
        self.data = data
        self.offset = offset
        self.currentOffset = offset
    }
    
    // -----
    
    public func extract<T: Deserializable>(index: Int) -> T {
        var size = 0
        let value: T = T.deserialize(data, currentOffset, &size)
        currentOffset += size
        return value
    }
    
    public func extract<T: Deserializable>(index: Int) -> T? {
        var size = 0
        let value: T? = T.deserialize(data, currentOffset, &size)
        currentOffset += size
        return value
    }
    
    public func extract<T: Deserializable>(index: Int) -> Array<T>? {
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

}
