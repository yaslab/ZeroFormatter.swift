//
//  ZeroFormattable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public func _fixedSize(_ types: [Formattable.Type]) -> Int? {
    var size = 0
    for type in types {
        guard let length = type.length else {
            return nil
        }
        size += length
    }
    return size
}

// MARK: - Basic Protocol

public protocol Formattable {
    
    static var length: Int? { get }

}

public protocol Serializable: Formattable {

    static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self) -> Int
    static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self?) -> Int
    
    static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self
    static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self?

}

// MARK: - Primitive Protocol

public protocol PrimitiveSerializable: Serializable {}

// MARK: - Object Protocol

public protocol ObjectSerializable: Serializable {
    
    static func serialize(_ value: Self, _ builder: ObjectBuilder)
    static func deserialize(_ extractor: ObjectExtractor) -> Self
    
}

public extension ObjectSerializable {
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self) -> Int {
        let builder = ObjectBuilder(bytes)
        serialize(value, builder)
        let length = builder.build()
        return length
    }

    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self?) -> Int {
        if let value = value {
            return serialize(bytes, -1, value)
        } else {
            return BinaryUtility.serialize(bytes, -1) // byteSize
        }
    }

}

public extension ObjectSerializable {
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self {
        let value: Self? = deserialize(bytes, offset, &byteSize)
        if value == nil {
            preconditionFailure()
        }
        return value!
    }

    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self? {
        let extractor = ObjectExtractor(bytes, offset)
        if extractor.byteSize < 0 {
            return nil
        }
        let value = deserialize(extractor)
        byteSize += extractor.byteSize
        return value
    }
    
}

// MARK: - Struct Protocol

public protocol StructSerializable: Serializable {
    
    static func serialize(_ value: Self, _ builder: StructBuilder)
    static func deserialize(_ extractor: StructExtractor) -> Self
    
}

public extension StructSerializable {
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self) -> Int {
        let builder = StructBuilder(bytes)
        serialize(value, builder)
        let length = builder.byteSize
        return length
    }
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Self?) -> Int {
        if let value = value {
            return serialize(bytes, -1, value)
        } else {
            return BinaryUtility.serialize(bytes, -1) // byteSize
        }
    }
    
}

public extension StructSerializable {
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self {
        let value: Self? = deserialize(bytes, offset, &byteSize)
        if value == nil {
            preconditionFailure()
        }
        return value!
    }
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Self? {
        let extractor = StructExtractor(bytes, offset)
        if extractor.byteSize < 0 {
            byteSize += extractor.byteSize
            return nil
        }
        let value = deserialize(extractor)
        byteSize += extractor.byteSize
        return value
    }
    
}
