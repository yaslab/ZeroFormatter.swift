//
//  PrimitiveDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol PrimitiveDeserializable {
    static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Self
    static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Self?
}

internal func _deserialize<T: PrimitiveDeserializable>(_ data: Data, _ offset: Int) -> T {
    return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
        return (bytes + offset).withMemoryRebound(to: T.self, capacity: 1) {
            return $0[0]
        }
    }
}

internal func _deserialize<T: PrimitiveDeserializable>(_ data: Data, _ offset: Int) -> T? {
    return data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
        let p = bytes + offset
        let hasValue = p[0]
        if hasValue == 0 {
            return nil
        }
        return (p + 1).withMemoryRebound(to: T.self, capacity: 1) {
            return $0[0]
        }
    }
}

extension Int8: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int8 {
        size = 1
        return _deserialize(data, offset)
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int8? {
        size = 2
        return _deserialize(data, offset)
    }
}
extension Int16: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int16 {
        size = 2
        let value: Int16 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int16? {
        size = 3
        let value: Int16? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension Int32: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int32 {
        size = 4
        let value: Int32 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int32? {
        size = 5
        let value: Int32? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension Int64: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int64 {
        size = 8
        let value: Int64 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Int64? {
        size = 9
        let value: Int64? = _deserialize(data, offset)
        return value?.littleEndian
    }
}

extension UInt8: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt8 {
        size = 1
        return _deserialize(data, offset)
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt8? {
        size = 2
        return _deserialize(data, offset)
    }
}
extension UInt16: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt16 {
        size = 2
        let value: UInt16 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt16? {
        size = 3
        let value: UInt16? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension UInt32: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt32 {
        size = 4
        let value: UInt32 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt32? {
        size = 5
        let value: UInt32? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension UInt64: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt64 {
        size = 8
        let value: UInt64 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> UInt64? {
        size = 9
        let value: UInt64? = _deserialize(data, offset)
        return value?.littleEndian
    }
}

extension Float: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Float {
        size = 4
        let value: UInt32 = _deserialize(data, offset)
        return Float(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Float? {
        size = 5
        let value: UInt32? = _deserialize(data, offset)
        if let value = value {
            return Float(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Double: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Double {
        size = 8
        let value: UInt64 = _deserialize(data, offset)
        return Double(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Double? {
        size = 9
        let value: UInt64? = _deserialize(data, offset)
        if let value = value {
            return Double(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Bool: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Bool {
        size = 1
        let value: UInt8 = _deserialize(data, offset)
        return value != 0
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Bool? {
        size = 2
        let value: UInt8? = _deserialize(data, offset)
        if let value = value {
            return value != 0
        } else {
            return nil
        }
    }
}

extension Date: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Date {
        size = 12
        let seconds: Int64 = _deserialize(data, offset)
        let nanos: Int32 = _deserialize(data, offset + 8)
        var unixTime = TimeInterval(seconds.littleEndian)
        unixTime += TimeInterval(nanos.littleEndian) / 1_000_000_000
        return Date(timeIntervalSince1970: unixTime)
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> Date? {
        size = 13
        let hasValue: UInt8 = _deserialize(data, offset)
        if hasValue == 0 {
            return nil
        }
        var size = 0
        let date: Date = deserialize(data, offset + 1, &size)
        return date
    }
}
extension String: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> String {
        let length: Int32 = _deserialize(data, offset)
        if length <= 0 {
            size = 4
            return ""
        }
        size = 4 + Int(length)
        let utf8Data = data.subdata(in: offset ..< (offset + Int(length)))
        return String(data: utf8Data, encoding: .utf8)!
    }
    public static func deserialize(_ data: Data, _ offset: Int, _ size: inout Int) -> String? {
        let length: Int32 = _deserialize(data, offset)
        if length < 0 {
            size = 4
            return nil
        } else if length == 0 {
            size = 4
            return ""
        }
        size = 4 + Int(length)
        let utf8Data = data.subdata(in: offset ..< (offset + Int(length)))
        return String(data: utf8Data, encoding: .utf8)
    }
}
