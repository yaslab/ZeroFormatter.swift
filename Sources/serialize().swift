//
//  serialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public func serialize<T: Serializable>(_ value: T) -> NSData {
    let bytes = NSMutableData()
    _ = T.serialize(bytes, 0, value)
    return bytes
}

public func serialize<T: Serializable>(_ value: T?) -> NSData {
    let bytes = NSMutableData()
    _ = T.serialize(bytes, 0, value)
    return bytes
}

public func serialize<T: Serializable>(_ value: Array<T>?) -> NSData {
    let bytes = NSMutableData()
    _ = ArraySerializer.serialize(bytes, 0, value)
    return bytes
}

public func serialize<T: Serializable>(_ value: Array<Array<T>>?) -> NSData {
    let bytes = NSMutableData()
    _ = ArraySerializer.serialize(bytes, 0, value)
    return bytes
}

public func serialize<T: Serializable>(_ value: List<T>?) -> NSData {
    let bytes = NSMutableData()
    _ = ListSerializer.serialize(bytes, value)
    return bytes
}

public func serializeAsList<T: Serializable>(_ value: Array<T>?) -> NSData {
    let bytes = NSMutableData()
    _ = ListSerializer.serializeAsList(bytes, value)
    return bytes
}
