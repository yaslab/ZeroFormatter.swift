//
//  PrimitiveDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

// TODO: endian
internal func _deserialize<T: PrimitiveDeserializable>(_ bytes: NSData, _ offset: Int) -> T {
    return (bytes.bytes + offset).assumingMemoryBound(to: T.self)[0]
}

// TODO: endian
internal func _deserialize<T: PrimitiveDeserializable>(_ bytes: NSData, _ offset: Int) -> T? {
    let p = bytes.bytes + offset
    let hasValue = p.assumingMemoryBound(to: Int8.self)[0]
    if hasValue == 0 {
        return nil
    }
    return (p + 1).assumingMemoryBound(to: T.self)[0]
}

extension Int8: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int8 {
        size = 1
        return _deserialize(bytes, offset)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int8? {
        size = 2
        return _deserialize(bytes, offset)
    }
}
extension Int16: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int16 {
        size = 2
        let value: Int16 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int16? {
        size = 3
        let value: Int16? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}
extension Int32: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int32 {
        size = 4
        let value: Int32 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int32? {
        size = 5
        let value: Int32? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}
extension Int64: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int64 {
        size = 8
        let value: Int64 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Int64? {
        size = 9
        let value: Int64? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}

extension UInt8: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt8 {
        size = 1
        return _deserialize(bytes, offset)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt8? {
        size = 2
        return _deserialize(bytes, offset)
    }
}
extension UInt16: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt16 {
        size = 2
        let value: UInt16 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt16? {
        size = 3
        let value: UInt16? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}
extension UInt32: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt32 {
        size = 4
        let value: UInt32 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt32? {
        size = 5
        let value: UInt32? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}
extension UInt64: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt64 {
        size = 8
        let value: UInt64 = _deserialize(bytes, offset)
        return value.littleEndian
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> UInt64? {
        size = 9
        let value: UInt64? = _deserialize(bytes, offset)
        return value?.littleEndian
    }
}

extension Float: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Float {
        size = 4
        let value: UInt32 = _deserialize(bytes, offset)
        return Float(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Float? {
        size = 5
        let value: UInt32? = _deserialize(bytes, offset)
        if let value = value {
            return Float(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Double: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Double {
        size = 8
        let value: UInt64 = _deserialize(bytes, offset)
        return Double(bitPattern: value.littleEndian)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Double? {
        size = 9
        let value: UInt64? = _deserialize(bytes, offset)
        if let value = value {
            return Double(bitPattern: value.littleEndian)
        } else {
            return nil
        }
    }
}
extension Bool: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Bool {
        size = 1
        let value: UInt8 = _deserialize(bytes, offset)
        return value != 0
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Bool? {
        size = 2
        let value: UInt8? = _deserialize(bytes, offset)
        if let value = value {
            return value != 0
        } else {
            return nil
        }
    }
}

extension Date: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Date {
        size = 12
        let seconds: Int64 = _deserialize(bytes, offset)
        let nanos: Int32 = _deserialize(bytes, offset + 8)
        var unixTime = TimeInterval(seconds.littleEndian)
        unixTime += TimeInterval(nanos.littleEndian) / 1_000_000_000
        return Date(timeIntervalSince1970: unixTime)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> Date? {
        size = 13
        let hasValue: UInt8 = _deserialize(bytes, offset)
        if hasValue == 0 {
            return nil
        }
        var size = 0
        let date: Date = deserialize(bytes, offset + 1, &size)
        return date
    }
}
extension String: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> String {
        size = 4
        let length: Int32 = _deserialize(bytes, offset)
        if length <= 0 {
            return ""
        }
        size += Int(length)
        let start = offset + 4
        //let end = start + Int(length)
        //let utf8Data = bytes.subdata(in: start ..< end)
        //return String(data: utf8Data, encoding: .utf8)!
        let bufferSize = Int(length) + 1
        let buffer = malloc(bufferSize).assumingMemoryBound(to: UInt8.self)
        defer {
            free(buffer)
        }
        memset(buffer, 0 , bufferSize)
        memcpy(buffer, bytes.bytes + start, Int(length))
        return String(cString: buffer)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ size: inout Int) -> String? {
        size = 4
        let length: Int32 = _deserialize(bytes, offset)
        if length < 0 {
            return nil
        } else if length == 0 {
            return ""
        }
        size += Int(length)
        let start = offset + 4
        //let end = start + Int(length)
        //let utf8Data = bytes.subdata(in: start ..< end)
        //eturn String(data: utf8Data, encoding: .utf8)
        let bufferSize = Int(length) + 1
        let buffer = malloc(bufferSize).assumingMemoryBound(to: UInt8.self)
        defer {
            free(buffer)
        }
        memset(buffer, 0 , bufferSize)
        memcpy(buffer, bytes.bytes + start, Int(length))
        return String(cString: buffer)
    }
}
