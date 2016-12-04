//
//  ObjectSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol ObjectSerializable: ZeroFormattable {
    static func serialize(obj: Self, builder: ObjectBuilder)
}

public class ObjectBuilder {
    
    private let data: NSMutableData
    private let offset: Int
    
    private var appendFunctions = [(() -> Void)]()
    
    internal init(_ data: NSMutableData) {
        self.data = data
        self.offset = data.length
    }
    
    private func begin() {
        let lastIndex = appendFunctions.count - 1
        
        let zero = Int32(0)
        // byteSize
        _serialize(data, zero)
        // lastIndex
        _serialize(data, Int32(lastIndex).littleEndian)
        // indexOffset
        for _ in 0 ... lastIndex {
            _serialize(data, zero)
        }
    }
    
    private func updateIndexOffset(_ index: Int) {
        let indexOffset = Int32(data.length)
        
        let p = data.mutableBytes + offset + 4 + 4 + (4 * index)
        p.assumingMemoryBound(to: Int32.self)[0] = indexOffset.littleEndian
    }
    
    private func end() {
        let byteSize = Int32(data.length - offset)

        let p = data.mutableBytes + offset
        p.assumingMemoryBound(to: Int32.self)[0] = byteSize.littleEndian
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
        appendFunctions.append({ [unowned self] in _ = T.serialize(self.data, value) })
    }
    
    public func append<T: PrimitiveSerializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in _ = T.serialize(self.data, value) })
    }
    
    public func append<T: PrimitiveSerializable>(_ values: Array<T>?) {
        appendFunctions.append({ [unowned self] in
            if let values = values {
                let length = Int32(values.count)
                _serialize(self.data, length.littleEndian)
                for value in values {
                    _serialize(self.data, value)
                }
            } else {
                let length = Int32(-1)
                _serialize(self.data, length.littleEndian)
            }
        })
    }
    
    // -----
    
    public func append<T: ObjectSerializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in
            if let value = value {
                let builder = ObjectBuilder(self.data)
                T.serialize(obj: value, builder: builder)
                builder.build()
            } else {
                let byteSize = Int32(-1).littleEndian
                _serialize(self.data, byteSize)
            }
        })
    }
    
    public func append<T: ObjectSerializable>(_ values: Array<T>?) {
        appendFunctions.append({ [unowned self] in
            if let values = values {
                let length = Int32(values.count)
                _serialize(self.data, length.littleEndian)
                for value in values {
                    let builder = ObjectBuilder(self.data)
                    T.serialize(obj: value, builder: builder)
                    builder.build()
                }
            } else {
                let length = Int32(-1)
                _serialize(self.data, length.littleEndian)
            }
        })
    }
    
    // -----
    
    public func append<T: StructSerializable>(_ value: T) {
        appendFunctions.append({ [unowned self] in
            let builder = StructBuilder(self.data)
            T.serialize(obj: value, builder: builder)
        })
    }
    
    public func append<T: StructSerializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in
            if let value = value {
                _serialize(self.data, UInt8(1)) // hasValue
                let builder = StructBuilder(self.data)
                T.serialize(obj: value, builder: builder)
            } else {
                _serialize(self.data, UInt8(0)) // hasValue
            }
        })
    }
    
    public func append<T: StructSerializable>(_ values: Array<T>?) {
        appendFunctions.append({ [unowned self] in
            if let values = values {
                let length = Int32(values.count)
                _serialize(self.data, length.littleEndian)
                for value in values {
                    let builder = StructBuilder(self.data)
                    T.serialize(obj: value, builder: builder)
                }
            } else {
                let length = Int32(-1)
                _serialize(self.data, length.littleEndian)
            }
        })
    }
    
}
