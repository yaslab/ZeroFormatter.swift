//
//  PrimitiveDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol PrimitiveDeserializable {
    static func deserialize(_ data: Data, _ offset: Int) -> Self
    static func deserialize(_ data: Data, _ offset: Int) -> Self?
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
    public static func deserialize(_ data: Data, _ offset: Int) -> Int8 {
        return _deserialize(data, offset)
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Int8? {
        return _deserialize(data, offset)
    }
}
extension Int16: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Int16 {
        let value: Int16 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Int16? {
        let value: Int16? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension Int32: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Int32 {
        let value: Int32 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Int32? {
        let value: Int32? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension Int64: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Int64 {
        let value: Int64 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Int64? {
        let value: Int64? = _deserialize(data, offset)
        return value?.littleEndian
    }
}

extension UInt8: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt8 {
        return _deserialize(data, offset)
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt8? {
        return _deserialize(data, offset)
    }
}
extension UInt16: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt16 {
        let value: UInt16 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt16? {
        let value: UInt16? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension UInt32: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt32 {
        let value: UInt32 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt32? {
        let value: UInt32? = _deserialize(data, offset)
        return value?.littleEndian
    }
}
extension UInt64: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt64 {
        let value: UInt64 = _deserialize(data, offset)
        return value.littleEndian
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> UInt64? {
        let value: UInt64? = _deserialize(data, offset)
        return value?.littleEndian
    }
}

extension Float: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Float {
        let value: UInt32 = _deserialize(data, offset)
        return Float(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Float? {
        let value: UInt32? = _deserialize(data, offset)
        if let value = value {
            return Float(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Double: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Double {
        let value: UInt64 = _deserialize(data, offset)
        return Double(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Double? {
        let value: UInt64? = _deserialize(data, offset)
        if let value = value {
            return Double(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Bool: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Bool {
        let value: UInt8 = _deserialize(data, offset)
        return value != 0
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Bool? {
        let value: UInt8? = _deserialize(data, offset)
        if let value = value {
            return value != 0
        } else {
            return nil
        }
    }
}

extension Date: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> Date {
        let seconds: Int64 = _deserialize(data, offset)
        let nanos: Int32 = _deserialize(data, offset + 8)
        var unixTime = TimeInterval(seconds.littleEndian)
        unixTime += TimeInterval(nanos.littleEndian) / 1_000_000_000
        return Date(timeIntervalSince1970: unixTime)
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> Date? {
        let hasValue: UInt8 = _deserialize(data, offset)
        if hasValue == 0 {
            return nil
        }
        let date: Date = deserialize(data, offset + 1)
        return date
    }
}
extension String: PrimitiveDeserializable {
    public static func deserialize(_ data: Data, _ offset: Int) -> String {
        let length: Int32 = _deserialize(data, offset)
        if length <= 0 {
            return ""
        }
        let utf8Data = data.subdata(in: offset ..< (offset + Int(length)))
        return String(data: utf8Data, encoding: .utf8)!
    }
    public static func deserialize(_ data: Data, _ offset: Int) -> String? {
        let length: Int32 = _deserialize(data, offset)
        if length < 0 {
            return nil
        } else if length == 0 {
            return ""
        }
        let utf8Data = data.subdata(in: offset ..< (offset + Int(length)))
        return String(data: utf8Data, encoding: .utf8)
    }
}
