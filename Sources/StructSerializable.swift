//
//  StructSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol StructSerializable: ZeroFormattable {
    static func serialize(obj: Self, builder: StructBuilder)
}

public class StructBuilder {
    
    private let data: NSMutableData
    private let offset: Int
    
    internal init(_ data: NSMutableData) {
        self.data = data
        self.offset = data.length
    }
    
    var currentSize: Int {
        return data.length - offset
    }

    // -----
    
    public func append<T: PrimitiveSerializable>(_ value: T) {
        _ = T.serialize(data, value)
    }
    
    public func append<T: PrimitiveSerializable>(_ value: T?) {
        _ = T.serialize(data, value)
    }
    
    public func append<T: PrimitiveSerializable>(_ values: Array<T>?) {
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
    }
    
    // -----
    
    public func append<T: ObjectSerializable>(_ value: T?) {
        if let value = value {
            let builder = ObjectBuilder(data)
            T.serialize(obj: value, builder: builder)
            _ = builder.build()
        } else {
            let byteSize = Int32(-1).littleEndian
            _serialize(data, byteSize)
        }
    }
    
    public func append<T: ObjectSerializable>(_ values: Array<T>?) {
        if let values = values {
            let length = Int32(values.count)
            _serialize(self.data, length.littleEndian)
            for value in values {
                let builder = ObjectBuilder(self.data)
                T.serialize(obj: value, builder: builder)
                _ = builder.build()
            }
        } else {
            let length = Int32(-1)
            _serialize(self.data, length.littleEndian)
        }
    }
    
    // -----
    
    public func append<T: StructSerializable>(_ value: T) {
        let builder = StructBuilder(data)
        T.serialize(obj: value, builder: builder)
    }
    
    public func append<T: StructSerializable>(_ value: T?) {
        if let value = value {
            _serialize(self.data, UInt8(1)) // hasValue
            let builder = StructBuilder(data)
            T.serialize(obj: value, builder: builder)
        } else {
            _serialize(self.data, UInt8(0)) // hasValue
        }
    }
    
    public func append<T: StructSerializable>(_ values: Array<T>?) {
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
    }
    
}
