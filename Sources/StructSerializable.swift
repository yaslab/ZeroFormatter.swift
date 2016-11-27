//
//  StructSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol StructSerializable {
    static func serialize(obj: Self, builder: StructBuilder)
}

public class StructBuilder {
    
    private let data: NSMutableData
    private let offset: Int
    
    internal init(_ data: NSMutableData) {
        self.data = data
        self.offset = data.length
    }

    // -----
    
    public func append<T: PrimitiveSerializable>(_ value: T) {
        _serialize(data, value)
    }
    
    public func append<T: PrimitiveSerializable>(_ value: T?) {
        _serialize(data, value)
    }
    
    // -----
    
    public func append<T: ObjectSerializable>(_ value: T) {
        let builder = ObjectBuilder(data)
        T.serialize(obj: value, builder: builder)
        builder.build()
    }
    
    public func append<T: ObjectSerializable>(_ value: T?) {
        if let value = value {
            let builder = ObjectBuilder(data)
            T.serialize(obj: value, builder: builder)
            builder.build()
        } else {
            _serialize(data, Int32(-1))
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
    
}
