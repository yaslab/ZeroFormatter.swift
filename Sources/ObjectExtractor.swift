//
//  ObjectExtractor.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class ObjectExtractor {

    private let bytes: NSData
    private let offset: Int
    
    public let byteSize: Int
    public let isNil: Bool
    
    public init(_ bytes: NSData, _ offset: Int) {
        self.bytes = bytes
        self.offset = offset
        var tmp = 0
        let byteSize: Int = BinaryUtility.deserialize(bytes, offset, &tmp)
        self.byteSize = byteSize
        self.isNil = (byteSize < 0)
    }
    
    // -----
    
    public func extract<T: Serializable>(index: Int) -> T {
        var tmp = 0
        let indexOffset: Int = BinaryUtility.deserialize(bytes, offset + 4 + 4 + (4 * index), &tmp)
        return T.deserialize(bytes, Int(indexOffset), &tmp)
    }

    public func extract<T: Serializable>(index: Int) -> T? {
        var tmp = 0
        let indexOffset: Int = BinaryUtility.deserialize(bytes, offset + 4 + 4 + (4 * index), &tmp)
        return T.deserialize(bytes, Int(indexOffset), &tmp)
    }
    
    public func extract<T: Serializable>(index: Int) -> Array<T>? {
        var tmp = 0
        let indexOffset: Int = BinaryUtility.deserialize(bytes, offset + 4 + 4 + (4 * index), &tmp)
        
        var byteSize = 0
        let length: Int = BinaryUtility.deserialize(bytes, indexOffset, &byteSize)
        if length < 0 {
            return nil
        }
        
        var array = Array<T>()
        for _ in 0 ..< length {
            array.append(T.deserialize(bytes, indexOffset + byteSize, &byteSize))
        }
        return array
    }
    
}
