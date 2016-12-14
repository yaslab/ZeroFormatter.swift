//
//  StructBuilder.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class StructBuilder {
    
    private let bytes: NSMutableData
    private let offset: Int
    
    internal init(_ bytes: NSMutableData) {
        self.bytes = bytes
        self.offset = bytes.length
    }
    
    var byteSize: Int {
        return bytes.length - offset
    }

    // -----
    
    public func append<T: Serializable>(_ value: T) {
        _ = T.serialize(bytes, -1, value)
    }
    
    public func append<T: Serializable>(_ value: T?) {
        _ = T.serialize(bytes, -1, value)
    }
    
    public func append<T: Serializable>(_ value: Array<T>?) {
        _ = ArraySerializer.serialize(bytes, -1, value)
    }

}
