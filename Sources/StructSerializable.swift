//
//  StructSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/27.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class StructBuilder {
    
    private let data: NSMutableData
    private let offset: Int
    
    internal init(_ data: NSMutableData) {
        self.data = data
        self.offset = data.length
    }
    
    var currentSize: Int {
        return data.length - offset
    }

    // -----
    
    public func append<T: Serializable>(_ value: T) {
        _ = T.serialize(data, 0, value)
    }
    
    public func append<T: Serializable>(_ value: T?) {
        _ = T.serialize(data, 0, value)
    }
    
    public func append<T: Serializable>(_ values: Array<T>?) {
        if let values = values {
            let length = Int32(values.count)
            _serialize(self.data, length.littleEndian)
            for value in values {
                T.serialize(self.data, 0, value)
            }
        } else {
            let length = Int32(-1)
            _serialize(self.data, length.littleEndian)
        }
    }

}
