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

// MARK: - Array

// TODO: Use ArraySerializer
public func serialize<T: PrimitiveSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            _ = T.serialize(data, value)
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// TODO: Use ArraySerializer
public func serialize<T: ObjectSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            let builder = ObjectBuilder(data)
            T.serialize(obj: value, builder: builder)
            _ = builder.build()
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// TODO: Use ArraySerializer
public func serialize<T: StructSerializable>(_ values: Array<T>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            let builder = StructBuilder(data)
            T.serialize(obj: value, builder: builder)
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - Array in Array

public func serialize<T: PrimitiveSerializable>(_ values: Array<Array<T>>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            _ = ArraySerializer.serialize(data, value)
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

public func serialize<T: ObjectSerializable>(_ values: Array<Array<T>>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            _ = ArraySerializer.serialize(data, value)
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

public func serialize<T: StructSerializable>(_ values: Array<Array<T>>?) -> NSData {
    let data = NSMutableData()
    if let values = values {
        _serialize(data, Int32(values.count).littleEndian)
        for value in values {
            _ = ArraySerializer.serialize(data, value)
        }
    } else {
        _serialize(data, Int32(-1).littleEndian)
    }
    return data
}

// MARK: - List

public func serialize<T: PrimitiveSerializable>(_ values: List<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serialize(data, values)
    return data
}

public func serialize<T: ObjectSerializable>(_ values: List<T>?) -> NSData {
    let data = NSMutableData()
    _ = ListSerializer.serialize(data, values)
    return data
}

public func serialize<T: StructSerializable>(_ values: List<T>?) -> NSData {
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
