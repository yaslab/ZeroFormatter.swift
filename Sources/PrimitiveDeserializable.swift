//
//  PrimitiveDeserializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension Int8: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int8 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int8? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension Int16: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int16 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int16? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension Int32: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int32 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int32? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension Int64: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int64 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int64? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}

extension UInt8: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt8 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt8? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension UInt16: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt16 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt16? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension UInt32: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt32 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt32? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension UInt64: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt64 {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt64? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}

extension Float: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Float {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Float? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension Double: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Double {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Double? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}
extension Bool: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Bool {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Bool? {
        return BinaryUtility.deserialize(bytes, offset, &byteSize)
    }
}

extension Date: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Date {
        let start = byteSize
        let seconds: Int64 = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        let nanos: Int32 = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        var unixTime = TimeInterval(seconds)
        unixTime += TimeInterval(nanos) / 1_000_000_000.0
        return Date(timeIntervalSince1970: unixTime)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Date? {
        let start = byteSize
        let hasValue: Bool = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Date = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
}
extension String: PrimitiveDeserializable {
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> String {
        let start = byteSize
        let length: Int = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if length <= 0 {
            return ""
        }
        let bufferSize = length + 1
        let buffer = malloc(bufferSize).assumingMemoryBound(to: UInt8.self)
        defer {
            free(buffer)
        }
        memset(buffer, 0 , bufferSize)
        memcpy(buffer, bytes.bytes + offset + (byteSize - start), length)
        byteSize += length
        return String(cString: buffer)
    }
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> String? {
        let start = byteSize
        let length: Int = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if length < 0 {
            return nil
        }
        let bufferSize = length + 1
        let buffer = malloc(bufferSize).assumingMemoryBound(to: UInt8.self)
        defer {
            free(buffer)
        }
        memset(buffer, 0 , bufferSize)
        memcpy(buffer, bytes.bytes + offset + (byteSize - start), length)
        byteSize += length
        return String(cString: buffer)
    }
}
