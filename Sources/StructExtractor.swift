//
//  StructExtractor.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class StructExtractor {
    
    private let bytes: NSData
    private let offset: Int
    private var currentOffset: Int
    
    var byteSize: Int {
        return currentOffset - offset
    }
    
    internal init(_ bytes: NSData, _ offset: Int) {
        self.bytes = bytes
        self.offset = offset
        self.currentOffset = offset
    }
    
    // -----
    
    public func extract<T: Deserializable>(index: Int) -> T {
        return T.deserialize(bytes, currentOffset, &currentOffset)
    }
    
    public func extract<T: Deserializable>(index: Int) -> T? {
        return T.deserialize(bytes, currentOffset, &currentOffset)
    }
    
    public func extract<T: Deserializable>(index: Int) -> Array<T>? {
        let length: Int = BinaryUtility.deserialize(bytes, currentOffset, &currentOffset)
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        for _ in 0 ..< length {
            array.append(T.deserialize(bytes, currentOffset, &currentOffset))
        }
        return array
    }

}
