//
//  ObjectExtractor.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class ObjectExtractor {

    private let data: NSData
    private let offset: Int
    let isNil: Bool
    
    private var functions = [(() -> Void)]()
    
    var byteSize: Int {
        let byteSize = (data.bytes + offset).assumingMemoryBound(to: Int32.self)[0].littleEndian
        return Int(byteSize)
    }
    
    internal init(_ data: NSData, _ offset: Int) {
        self.data = data
        self.offset = offset

        let byteSize = (data.bytes + offset).assumingMemoryBound(to: Int32.self)[0].littleEndian
        self.isNil = byteSize == -1
    }
    
    // -----
    
    public func extract<T: Deserializable>(index: Int) -> T {
        let p = (data.bytes + offset + 4 + 4 + (4 * index))
        let indexOffset = p.assumingMemoryBound(to: Int32.self)[0].littleEndian
        var size = 0
        return T.deserialize(data, Int(indexOffset), &size)
    }

    public func extract<T: Deserializable>(index: Int) -> T? {
        let p = (data.bytes + offset + 4 + 4 + (4 * index))
        let indexOffset = p.assumingMemoryBound(to: Int32.self)[0].littleEndian
        var size = 0
        return T.deserialize(data, Int(indexOffset), &size)
    }
    
    public func extract<T: Deserializable>(index: Int) -> Array<T>? {
        let p = (data.bytes + offset + 4 + 4 + (4 * index))
        let indexOffset = p.assumingMemoryBound(to: Int32.self)[0].littleEndian
        
        let length: Int32 = _deserialize(data, Int(indexOffset))
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var _offset = 4
        for _ in 0 ..< length {
            var size = 0
            array.append(T.deserialize(data, _offset, &size))
            _offset += size
        }
        return array
    }
    
}
