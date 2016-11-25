//
//  PrimitiveSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol PrimitiveSerializable {
    static func serialize(_ data: NSMutableData, _ value: Self)
    static func serialize(_ data: NSMutableData, _ value: Self?)
}

internal func _serialize<T: PrimitiveSerializable>(_ data: NSMutableData, _ value: T) {
    var value = value
    withUnsafeBytes(of: &value) { (bytes) -> Void in
        data.append(
            bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
            length: bytes.count
        )
    }
}

internal func _serialize<T: PrimitiveSerializable>(_ data: NSMutableData, _ value: T?) {
    if let value = value {
        _serialize(data, UInt8(1)) // hasValue:bool(1)
        _serialize(data, value)
    } else {
        _serialize(data, UInt8(0)) // hasValue:bool(1)
        var zero: UInt64 = 0
        withUnsafeBytes(of: &zero) { (p) in
            data.append(p.baseAddress!, length: MemoryLayout<T>.size)
        }
    }
}

extension Int8: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Int8) {
        _serialize(data, value)
    }
    public static func serialize(_ data: NSMutableData, _ value: Int8?) {
        _serialize(data, value)
    }
}
extension Int16: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Int16) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Int16?) {
        _serialize(data, value?.littleEndian)
    }
}
extension Int32: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Int32) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Int32?) {
        _serialize(data, value?.littleEndian)
    }
}
extension Int64: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Int64) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Int64?) {
        _serialize(data, value?.littleEndian)
    }
}

extension UInt8: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: UInt8) {
        _serialize(data, value)
    }
    public static func serialize(_ data: NSMutableData, _ value: UInt8?) {
        _serialize(data, value)
    }
}
extension UInt16: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: UInt16) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: UInt16?) {
        _serialize(data, value?.littleEndian)
    }
}
extension UInt32: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: UInt32) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: UInt32?) {
        _serialize(data, value?.littleEndian)
    }
}
extension UInt64: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: UInt64) {
        _serialize(data, value.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: UInt64?) {
        _serialize(data, value?.littleEndian)
    }
}

extension Float32: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Float) {
        _serialize(data, value.bitPattern.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Float?) {
        _serialize(data, value?.bitPattern.littleEndian)
    }
}
extension Float64: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Double) {
        _serialize(data, value.bitPattern.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Double?) {
        _serialize(data, value?.bitPattern.littleEndian)
    }
}
extension Bool: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Bool) {
        let intValue: UInt8 = value ? 1 : 0
        _serialize(data, intValue)
    }
    public static func serialize(_ data: NSMutableData, _ value: Bool?) {
        var intValue: UInt8? = nil
        if let value = value {
            intValue = value ? 1 : 0
        }
        _serialize(data, intValue)
    }
}

extension Date: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: Date) {
        let unixTime = value.timeIntervalSince1970
        let seconds = Int64(unixTime)
        let nanos = Int32((abs(unixTime) - floor(abs(unixTime))) * 1_000_000_000)
        _serialize(data, seconds.littleEndian)
        _serialize(data, nanos.littleEndian)
    }
    public static func serialize(_ data: NSMutableData, _ value: Date?) {
        if let value = value {
            _serialize(data, Int8(1)) // hasValue:bool(1)
            serialize(data, value)
        } else {
            _serialize(data, Int8(0)) // hasValue:bool(1)
            _serialize(data, Int64(0)) // seconds:long(8)
            _serialize(data, Int32(0)) // nanos:int(4)
        }
    }
}
extension String: PrimitiveSerializable {
    public static func serialize(_ data: NSMutableData, _ value: String) {
        let utf8Data = value.data(using: .utf8)!
        var length = Int32(utf8Data.count).littleEndian
        withUnsafeBytes(of: &length) { (bytes) -> Void in
            data.append(
                bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                length: bytes.count
            )
        }
        data.append(utf8Data)
    }
    public static func serialize(_ data: NSMutableData, _ value: String?) {
        if let value = value {
            serialize(data, value)
        } else {
            var length = Int32(-1).littleEndian
            withUnsafeBytes(of: &length) { (bytes) -> Void in
                data.append(
                    bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                    length: bytes.count
                )
            }
        }
    }
}
