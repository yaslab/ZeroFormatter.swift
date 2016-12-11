//
//  ZeroFormatter.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol ZeroFormattable {
    static var fixedSize: Int? { get }
}

public func _fixedSize(_ types: [ZeroFormattable.Type]) -> Int? {
    var size = 0
    for type in types {
        guard let fixedSize = type.fixedSize else {
            return nil
        }
        size += fixedSize
    }
    return size
}
