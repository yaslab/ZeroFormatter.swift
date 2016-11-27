//
//  ObjectDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol ObjectDeserializable {
    static func deserialize(extractor: ObjectExtractor) -> Self
}

public class ObjectExtractor {

    private let data: Data
    private let offset: Int
    let isNil: Bool
    
    private var functions = [(() -> Void)]()
    
    internal init(_ data: Data, _ offset: Int) {
        self.data = data
        self.offset = offset
        
        let byteSize = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Int32 in
            let p = bytes + offset
            return p.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        self.isNil = byteSize == -1
    }
    
    internal func extract<T: PrimitiveDeserializable>(index: Int) -> T {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            return T.deserialize(data, Int(indexOffset))
        }
    }

    internal func extract<T: PrimitiveDeserializable>(index: Int) -> T? {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            return T.deserialize(data, Int(indexOffset))
        }
    }
    
    // -----
    
    internal func extract<T: ObjectDeserializable>(index: Int) -> T {
        let indexOffset: Int32 = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let head = bytes + offset + 4 + 4 + (4 * index)
            return head.withMemoryRebound(to: Int32.self, capacity: 1) { $0[0].littleEndian }
        }
        let extractor = ObjectExtractor(data, Int(indexOffset))
        if extractor.isNil {
            // TODO: throw error
        }
        return T.deserialize(extractor: extractor)
    }
    
    internal func extract<T: ObjectDeserializable>(index: Int) -> T? {
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

}
