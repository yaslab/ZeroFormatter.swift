//
//  ObjectSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol ObjectSerializable {
    static func serialize(obj: Self, builder: ObjectBuilder)
}

public class ObjectBuilder {
    
    private var data: Data
    private let offset: Int
    
    private var appendFunctions = [(() -> Void)]()
    
    internal init(_ data: inout Data) {
        self.data = data
        self.offset = data.count
    }
    
    private func begin() {
        let lastIndex = appendFunctions.count - 1
        
        let zero = Int32(0)
        // byteSize
        _serialize(&data, zero)
        // lastIndex
        _serialize(&data, Int32(lastIndex).littleEndian)
        // indexOffset
        for _ in 0 ... lastIndex {
            _serialize(&data, zero)
        }
    }
    
    private func updateIndexOffset(_ index: Int) {
        let indexOffset = Int32(data.count)
        
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
            (bytes + offset + 4 + 4 + (4 * index)).withMemoryRebound(to: Int32.self, capacity: 1) {
                $0[0] = indexOffset.littleEndian
            }
        }
    }
    
    private func end() {
        let byteSize = Int32(data.count - offset)
        
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
            (bytes + offset).withMemoryRebound(to: Int32.self, capacity: 1) {
                $0[0] = byteSize.littleEndian
            }
        }
    }
    
    internal func build() {
        begin()
        for (i, appendFunction) in appendFunctions.enumerated() {
            updateIndexOffset(i)
            appendFunction()
        }
        end()
    }
    
    // -----
    
    public func append<T: PrimitiveSerializable>(_ value: T) {
        appendFunctions.append({ [unowned self] in _serialize(&self.data, value) })
    }
    
    public func append<T: PrimitiveSerializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in _serialize(&self.data, value) })
    }
    
    // -----
    
    public func append<T: ObjectSerializable>(_ value: T) {
        appendFunctions.append({ [unowned self] in
            let builder = ObjectBuilder(&self.data)
            T.serialize(obj: value, builder: builder)
            builder.build()
        })
    }
    
    public func append<T: ObjectSerializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in
            if let value = value {
                let builder = ObjectBuilder(&self.data)
                T.serialize(obj: value, builder: builder)
                builder.build()
            } else {
                _serialize(&self.data, Int32(-1))
            }
        })
    }
    
}
