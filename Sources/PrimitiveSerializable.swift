//
//  PrimitiveSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal func _serialize<T: PrimitiveSerializable>(_ bytes: NSMutableData, _ value: T) {
    var value = value
    withUnsafeBytes(of: &value) {
        bytes.append($0.baseAddress!.assumingMemoryBound(to: UInt8.self), length: $0.count)
    }
}

internal func _serialize<T: PrimitiveSerializable>(_ bytes: NSMutableData, _ value: T?) {
    if let value = value {
        _serialize(bytes, Int8(1)) // hasValue:bool(1)
        _serialize(bytes, value)
    } else {
        _serialize(bytes, Int8(0)) // hasValue:bool(1)
        var zero: Int64 = 0
        withUnsafeBytes(of: &zero) {
            bytes.append($0.baseAddress!, length: MemoryLayout<T>.size)
        }
    }
}

extension Int8: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int8) -> Int {
        _serialize(bytes, value)
        return 1
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int8?) -> Int {
        _serialize(bytes, value)
        return 2
    }
}
extension Int16: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int16) -> Int {
        _serialize(bytes, value.littleEndian)
        return 2
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int16?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 3
    }
}
extension Int32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int32) -> Int {
        _serialize(bytes, value.littleEndian)
        return 4
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int32?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 5
    }
}
extension Int64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int64) -> Int {
        _serialize(bytes, value.littleEndian)
        return 8
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int64?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 9
    }
}

extension UInt8: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt8) -> Int {
        _serialize(bytes, value)
        return 1
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt8?) -> Int {
        _serialize(bytes, value)
        return 2
    }
}
extension UInt16: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt16) -> Int {
        _serialize(bytes, value.littleEndian)
        return 2
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt16?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 3
    }
}
extension UInt32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt32) -> Int {
        _serialize(bytes, value.littleEndian)
        return 4
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt32?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 5
    }
}
extension UInt64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt64) -> Int {
        _serialize(bytes, value.littleEndian)
        return 8
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt64?) -> Int {
        _serialize(bytes, value?.littleEndian)
        return 9
    }
}

extension Float32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Float) -> Int {
        _serialize(bytes, value.bitPattern.littleEndian)
        return 4
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Float?) -> Int {
        _serialize(bytes, value?.bitPattern.littleEndian)
        return 5
    }
}
extension Float64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Double) -> Int {
        _serialize(bytes, value.bitPattern.littleEndian)
        return 8
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Double?) -> Int {
        _serialize(bytes, value?.bitPattern.littleEndian)
        return 9
    }
}
extension Bool: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Bool) -> Int {
        let intValue: UInt8 = value ? 1 : 0
        _serialize(bytes, intValue)
        return 1
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Bool?) -> Int {
        var intValue: UInt8? = nil
        if let value = value {
            intValue = value ? 1 : 0
        }
        _serialize(bytes, intValue)
        return 2
    }
}

extension Date: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Date) -> Int {
        let unixTime = value.timeIntervalSince1970
        let seconds = Int64(unixTime)
        let nanos = Int32((abs(unixTime) - floor(abs(unixTime))) * 1_000_000_000)
        _serialize(bytes, seconds.littleEndian)
        _serialize(bytes, nanos.littleEndian)
        return 12
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Date?) -> Int {
        if let value = value {
            _serialize(bytes, Int8(1)) // hasValue:bool(1)
            _ = serialize(bytes, 0, value)
        } else {
            _serialize(bytes, Int8(0)) // hasValue:bool(1)
            _serialize(bytes, Int64(0)) // seconds:long(8)
            _serialize(bytes, Int32(0)) // nanos:int(4)
        }
        return 13
    }
}
extension String: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: String) -> Int {
        let utf8Data = value.data(using: .utf8)!
        var length = Int32(utf8Data.count).littleEndian
        withUnsafeBytes(of: &length) {
            bytes.append(
                $0.baseAddress!.assumingMemoryBound(to: UInt8.self),
                length: $0.count
            )
        }
        bytes.append(utf8Data)
        return 4 + utf8Data.count
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: String?) -> Int {
        if let value = value {
            return serialize(bytes, 0, value)
        } else {
            var length = Int32(-1).littleEndian
            withUnsafeBytes(of: &length) {
                bytes.append(
                    $0.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    length: $0.count
                )
            }
            return 4
        }
    }
}
