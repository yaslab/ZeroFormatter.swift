//
//  BinaryUtility.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/14.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

internal enum BinaryUtility {

    // -------------------------------------------------------------------------
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Bool) -> Int {
        return serialize(bytes, Int8(value ? 1 : 0))
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int8) -> Int {
        let byteSize = 1
        var value = value
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }

    internal static func serialize(_ bytes: NSMutableData, _ value: Int16) -> Int {
        let byteSize = 2
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int32) -> Int {
        let byteSize = 4
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int64) -> Int {
        let byteSize = 8
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }

    // MARK: -

    internal static func serialize(_ bytes: NSMutableData, _ value: UInt8) -> Int {
        let byteSize = 1
        var value = value
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt16) -> Int {
        let byteSize = 2
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt32) -> Int {
        let byteSize = 4
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt64) -> Int {
        let byteSize = 8
        var value = value.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }

    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Float) -> Int {
        let byteSize = 4
        var value = value.bitPattern.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Double) -> Int {
        let byteSize = 8
        var value = value.bitPattern.littleEndian
        withUnsafePointer(to: &value) { bytes.append($0, length: byteSize) }
        return byteSize
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Bool?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int8?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int16?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int32?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int64?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt8?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt16?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt32?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: UInt64?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Float?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Double?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    // MARK: -
    
    internal static func serialize(_ bytes: NSMutableData, _ value: Int) -> Int {
        return serialize(bytes, Int32(value))
    }

    internal static func serialize(_ bytes: NSMutableData, _ value: Int?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += serialize(bytes, true)
            byteSize += serialize(bytes, value)
        } else {
            byteSize += serialize(bytes, false)
        }
        return byteSize
    }
    
    // MARK: - Int (offset)
    
    internal static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int) -> Int {
        let byteSize = 4
        let value = Int32(value).littleEndian
        (bytes.mutableBytes + offset).assumingMemoryBound(to: Int32.self)[0] = value
        return byteSize
    }
    
    // -------------------------------------------------------------------------
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Bool {
        let value: Int8 = deserialize(bytes, offset, &byteSize)
        return (value != 0)
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int8 {
        byteSize += 1
        return (bytes.bytes + offset).assumingMemoryBound(to: Int8.self)[0]
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int16 {
        byteSize += 2
        return (bytes.bytes + offset).assumingMemoryBound(to: Int16.self)[0].littleEndian
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int32 {
        byteSize += 4
        return (bytes.bytes + offset).assumingMemoryBound(to: Int32.self)[0].littleEndian
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int64 {
        byteSize += 8
        return (bytes.bytes + offset).assumingMemoryBound(to: Int64.self)[0].littleEndian
    }

    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt8 {
        byteSize += 1
        return (bytes.bytes + offset).assumingMemoryBound(to: UInt8.self)[0]
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt16 {
        byteSize += 2
        return (bytes.bytes + offset).assumingMemoryBound(to: UInt16.self)[0].littleEndian
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt32 {
        byteSize += 4
        return (bytes.bytes + offset).assumingMemoryBound(to: UInt32.self)[0].littleEndian
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt64 {
        byteSize += 8
        return (bytes.bytes + offset).assumingMemoryBound(to: UInt64.self)[0].littleEndian
    }

    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Float {
        let value: UInt32 = deserialize(bytes, offset, &byteSize)
        return Float(bitPattern: value.littleEndian)
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Double {
        let value: UInt64 = deserialize(bytes, offset, &byteSize)
        return Double(bitPattern: value.littleEndian)
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Bool? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int8? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Int8 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int16? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Int16 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int32? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Int32 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int64? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Int64 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt8? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: UInt8 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt16? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: UInt16 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt32? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: UInt32 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> UInt64? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: UInt64 = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Float? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Float = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Double? {
        let start = byteSize
        let hasValue: Bool = deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: Double = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
    // MARK: -
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int {
        let value: Int32 = deserialize(bytes, offset, &byteSize)
        return Int(value)
    }
    
    internal static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> Int? {
        let value: Int32? = deserialize(bytes, offset, &byteSize)
        if let value = value {
            return Int(value)
        } else {
            return nil
        }
    }

}
