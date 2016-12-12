//
//  serialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public func serialize<T: Serializable>(_ value: T) -> NSData {
    let data = NSMutableData()
    _ = T.serialize(data, 0, value)
    return data
}

public func serialize<T: Serializable>(_ value: T?) -> NSData {
    let data = NSMutableData()
    _ = T.serialize(data, 0, value)
    return data
}

public func serialize<T: Serializable>(_ value: Array<T>?) -> NSData {
    let data = NSMutableData()
    ArraySerializer.serialize(data, value)
    return data
}

// TODO:
public func serialize<T: Serializable>(_ value: Array<Array<T>>?) -> NSData {
    let data = NSMutableData()
    ArraySerializer.serialize(data, value)
    return data
}

public func serialize<T: Serializable>(_ value: List<T>?) -> NSData {
    let data = NSMutableData()
    ListSerializer.serialize(data, value)
    return data
}

public func serializeAsList<T: Serializable>(_ value: Array<T>?) -> NSData {
    let data = NSMutableData()
    ListSerializer.serializeAsList(data, value)
    return data
}
