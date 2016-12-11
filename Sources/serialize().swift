//
//  serialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

// MARK: - PrimitiveSerializable

public func serialize<T: PrimitiveSerializable>(_ value: T) -> NSData {
    let data = NSMutableData()
    _ = T.serialize(data, value)
    return data
}

public func serialize<T: PrimitiveSerializable>(_ value: T?) -> NSData {
    let data = NSMutableData()
    _ = T.serialize(data, value)
    return data
}

// MARK: - ObjectSerializable

public func serialize<T: ObjectSerializable>(_ value: T?) -> NSData {
    let data = NSMutableData()
    if let value = value {
        let builder = ObjectBuilder(data)
        T.serialize(obj: value, builder: builder)
        _ = builder.build()
    } else {
        _serialize(data, Int32(-1))
    }
    return data
}

// MARK: - StructSerializable

public func serialize<T: StructSerializable>(_ value: T) -> NSData {
    let data = NSMutableData()
    let builder = StructBuilder(data)
    T.serialize(obj: value, builder: builder)
    return data
}

public func serialize<T: StructSerializable>(_ value: T?) -> NSData {
    let data = NSMutableData()
    if let value = value {
        _serialize(data, UInt8(1)) // hasValue
        let builder = StructBuilder(data)
        T.serialize(obj: value, builder: builder)
    } else {
        _serialize(data, UInt8(0)) // hasValue
    }
    return data
}

// MARK: - Array of PrimitiveSerializable

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: PrimitiveSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            _ = T.Iterator.Element.serialize(data, value)
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - Array of ObjectSerializable

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: ObjectSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            let builder = ObjectBuilder(data)
            T.Iterator.Element.serialize(obj: value, builder: builder)
            _ = builder.build()
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - Array of StructSerializable

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: StructSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            let builder = StructBuilder(data)
            T.Iterator.Element.serialize(obj: value, builder: builder)
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - Array in Array

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: Sequence, T.Iterator.Element.Iterator.Element: PrimitiveSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            _ = T.Iterator.Element.serialize(data, value)
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: Sequence, T.Iterator.Element.Iterator.Element: ObjectSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            _ = T.Iterator.Element.serialize(data, value)
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

public func serialize<T: Sequence>(_ values: T?) -> NSData where T.Iterator.Element: Sequence, T.Iterator.Element.Iterator.Element: StructSerializable {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(0).littleEndian)
        var length = 0
        for value in values {
            length += 1
            _ = T.Iterator.Element.serialize(data, value)
        }
        
        (data.mutableBytes + 0).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - List

public func serialize<T: ObjectSerializable>(_ values: List<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serialize(data, values)
    return data
}

// MARK: - List from Array

public func serializeAsList<T: PrimitiveSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serializeAsList(data, values)
    return data
}

public func serializeAsList<T: ObjectSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serializeAsList(data, values)
    return data
}

public func serializeAsList<T: StructSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serializeAsList(data, values)
    return data
}
