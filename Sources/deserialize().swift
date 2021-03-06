//
//  deserialize().swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/11.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public func deserialize<T: Serializable>(_ bytes: NSData) -> T {
    var byteSize = 0
    return T.deserialize(bytes, 0, &byteSize)
}

public func deserialize<T: Serializable>(_ bytes: NSData) -> T? {
    var byteSize = 0
    return T.deserialize(bytes, 0, &byteSize)
}

public func deserialize<T: Serializable>(_ bytes: NSData) -> Array<T>? {
    var byteSize = 0
    return ArraySerializer.deserialize(bytes, 0, &byteSize)
}

public func deserialize<T: Serializable>(_ bytes: NSData) -> List<T>? {
    if let itemSize = T.length {
        return FixedSizeList<T>(bytes: bytes, offset: 0, itemSize: itemSize)
    } else {
        return VariableSizeList<T>(bytes: bytes, offset: 0)
    }
}
