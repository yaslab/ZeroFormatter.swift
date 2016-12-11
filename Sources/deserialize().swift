//
//  deserialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

// MARK: - PrimitiveDeserializable

public func deserialize<T: PrimitiveDeserializable>(_ data: NSData) -> T {
    var size = 0
    return T.deserialize(data, 0, &size)
}

public func deserialize<T: PrimitiveDeserializable>(_ data: NSData) -> T? {
    var size = 0
    return T.deserialize(data, 0, &size)
}

// MARK: - ObjectDeserializable

public func deserialize<T: ObjectDeserializable>(_ data: NSData) -> T? {
    let extractor = ObjectExtractor(data, 0)
    if extractor.isNil {
        return nil
    }
    let obj: T = T.deserialize(extractor: extractor)
    return obj
}

// MARK: - StructDeserializable

public func deserialize<T: StructDeserializable>(_ data: NSData) -> T {
    let extractor = StructExtractor(data, 0)
    return T.deserialize(extractor: extractor)
}

public func deserialize<T: StructDeserializable>(_ data: NSData) -> T? {
    let extractor = StructExtractor(data, 0)
    let obj: T = T.deserialize(extractor: extractor)
    return obj
}

// MARK: - Array of PrimitiveDeserializable

public func deserialize<T: PrimitiveDeserializable>(_ data: NSData) -> Array<T>? {
    let length: Int32 = _deserialize(data, 0)
    if length < 0 {
        return nil
    }
    var array = Array<T>()
    var offset = 4
    for _ in 0 ..< length {
        var size = 0
        array.append(T.deserialize(data, offset, &size))
        offset += size
    }
    return array
}

// MARK: - Array of ObjectDeserializable

public func deserialize<T: ObjectDeserializable>(_ data: NSData) -> Array<T>? {
    let length: Int32 = _deserialize(data, 0)
    if length < 0 {
        return nil
    }
    var array = Array<T>()
    var offset = 4
    for _ in 0 ..< length {
        let extractor = ObjectExtractor(data, offset)
        array.append(T.deserialize(extractor: extractor))
        offset += extractor.size
    }
    return array
}

// MARK: - Array of StructDeserializable

public func deserialize<T: StructDeserializable>(_ data: NSData) -> Array<T>? {
    let length: Int32 = _deserialize(data, 0)
    if length < 0 {
        return nil
    }
    var array = Array<T>()
    var offset = 4
    for _ in 0 ..< length {
        let extractor = StructExtractor(data, offset)
        array.append(T.deserialize(extractor: extractor))
        offset += extractor.size
    }
    return array
}

// MARK: - List

public func deserialize<T: PrimitiveDeserializable>(_ data: NSData) -> List<T>? {
    return ListSerializer.deserialize(data: data, offset: 0)
}

public func deserialize<T: ObjectDeserializable>(_ data: NSData) -> List<T>? {
    return ListSerializer.deserialize(data: data, offset: 0)
}

public func deserialize<T: StructDeserializable>(_ data: NSData) -> List<T>? {
    return ListSerializer.deserialize(data: data, offset: 0)
}
