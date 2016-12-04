//
//  ObjectDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol ObjectDeserializable: ZeroFormattable {
    static func deserialize(extractor: ObjectExtractor) -> Self
}

public class ObjectExtractor {

    private let data: Data
    private let offset: Int
    let isNil: Bool
    
    private var functions = [(() -> Void)]()
    
    var size: Int {
        let byteSize: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        return Int(byteSize)
    }
    
    internal init(_ data: Data, _ offset: Int) {
        self.data = data
        self.offset = offset
        
        let byteSize = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int32 in
            let p = bytes + offset
            return p.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        self.isNil = byteSize == -1
    }
    
    // -----
    
    public func extract<T: PrimitiveDeserializable>(index: Int) -> T {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        var size = 0
        return T.deserialize(data, Int(indexOffset), &size)
    }

    public func extract<T: PrimitiveDeserializable>(index: Int) -> T? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        var size = 0
        return T.deserialize(data, Int(indexOffset), &size)
    }
    
    public func extract<T: PrimitiveDeserializable>(index: Int) -> Array<T>? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        
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
    
    // -----
    
    public func extract<T: ObjectDeserializable>(index: Int) -> T? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        let extractor = ObjectExtractor(data, Int(indexOffset))
        if extractor.isNil {
            return nil
        }
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }

    public func extract<T: ObjectDeserializable>(index: Int) -> Array<T>? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        
        let length: Int32 = _deserialize(data, Int(indexOffset))
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var _offset = 4
        for _ in 0 ..< length {
            let extractor = ObjectExtractor(data, _offset)
            let obj: T? = T.deserialize(extractor: extractor)
            array.append(obj!)
            _offset += extractor.size
        }
        return array
    }
    
    // -----
    
    public func extract<T: StructDeserializable>(index: Int) -> T {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        let extractor = StructExtractor(data, Int(indexOffset))
        return T.deserialize(extractor: extractor)
    }
    
    public func extract<T: StructDeserializable>(index: Int) -> T? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        let hasValue: UInt8 = _deserialize(data, Int(indexOffset))
        if hasValue == 0 {
            return nil
        }
        let extractor = StructExtractor(data, Int(indexOffset + 1))
        let obj: T = T.deserialize(extractor: extractor)
        return obj
    }
    
    public func extract<T: StructDeserializable>(index: Int) -> Array<T>? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        
        let length: Int32 = _deserialize(data, Int(indexOffset))
        if length < 0 {
            return nil
        }
        var array = Array<T>()
        var _offset = 4
        for _ in 0 ..< length {
            let extractor = StructExtractor(data, _offset)
            array.append(T.deserialize(extractor: extractor))
            _offset += extractor.size
        }
        return array
    }
    
}
