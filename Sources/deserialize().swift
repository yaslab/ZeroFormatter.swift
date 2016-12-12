//
//  deserialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public func deserialize<T: Deserializable>(_ bytes: NSData) -> T {
    var byteSize = 0
    return T.deserialize(bytes, 0, &byteSize)
}

public func deserialize<T: Deserializable>(_ bytes: NSData) -> T? {
    var byteSize = 0
    return T.deserialize(bytes, 0, &byteSize)
}

public func deserialize<T: Deserializable>(_ bytes: NSData) -> Array<T>? {
    let length: Int32 = _deserialize(bytes, 0)
    if length < 0 {
        return nil
    }
    var array = Array<T>()
    var offset = 4
    for _ in 0 ..< length {
        var byteSize = 0
        array.append(T.deserialize(bytes, offset, &byteSize))
        offset += byteSize
    }
    return array
}

public func deserialize<T: Deserializable>(_ bytes: NSData) -> List<T>? {
    if let itemSize = T.length {
        return FixedSizeList<T>(data: bytes, offset: 0, itemSize: itemSize)
    } else {
        return VariableSizeList<T>(data: bytes, offset: 0)
    }
}
