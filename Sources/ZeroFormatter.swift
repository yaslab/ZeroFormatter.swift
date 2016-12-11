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


extension Sequence {

    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int where T.Iterator.Element: PrimitiveSerializable {

        var byteSize = 4
        
        if let values = values {
            let offset = data.length
            _serialize(data, Int32(0).littleEndian) // length
            var length = 0
            for value in values {
                length += 1
                byteSize += T.Iterator.Element.serialize(data, value)
            }
            
            (data.mutableBytes + offset).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }

    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int where T.Iterator.Element: ObjectSerializable {
        
        var byteSize = 4
        
        if let values = values {
            let offset = data.length
            _serialize(data, Int32(0).littleEndian) // length
            var length = 0
            for value in values {
                length += 1
                let builder = ObjectBuilder(data)
                T.Iterator.Element.serialize(obj: value, builder: builder)
                byteSize += builder.build()
            }
            
            (data.mutableBytes + offset).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }

    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int where T.Iterator.Element: StructSerializable {
        
        var byteSize = 4
        
        if let values = values {
            let offset = data.length
            _serialize(data, Int32(0).littleEndian) // length
            var length = 0
            for value in values {
                length += 1
                let builder = StructBuilder(data)
                T.Iterator.Element.serialize(obj: value, builder: builder)
                byteSize += builder.currentSize
            }
            
            (data.mutableBytes + offset).assumingMemoryBound(to: Int32.self)[0] = Int32(length).littleEndian
        } else {
            _serialize(data, Int32(-1).littleEndian)
        }
        
        return byteSize
    }

    // Arran in Array
    
    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int
        where T.Iterator.Element: Sequence,
        T.Iterator.Element.Iterator.Element: PrimitiveSerializable {
        
            if let values = values {
                var byteSize = 0
                for value in values {
                    byteSize += serialize(data, value)
                }
                return byteSize
            } else {
                // TODO: nil
                return -1
            }
    }

    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int
        where T.Iterator.Element: Sequence,
        T.Iterator.Element.Iterator.Element: ObjectSerializable {
        
            if let values = values {
                var byteSize = 0
                for value in values {
                    byteSize += serialize(data, value)
                }
                return byteSize
            } else {
                // TODO: nil
                return -1
            }
    }
    
    static func serialize<T: Sequence>(_ data: NSMutableData, _ values: T?) -> Int
        where T.Iterator.Element: Sequence,
        T.Iterator.Element.Iterator.Element: StructSerializable {
        
            if let values = values {
                var byteSize = 0
                for value in values {
                    byteSize += serialize(data, value)
                }
                return byteSize
            } else {
                // TODO: nil
                return -1
            }
    }
    
}

extension Sequence {
    
    static func serialize<T: ObjectSerializable>(_ data: NSMutableData, _ values: List<T>?) -> Int {

        return ListSerializer.serialize(data, values)
    }

}
