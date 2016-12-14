//
//  PrimitiveSerializable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension Int8: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int8) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int8?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension Int16: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int16) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int16?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension Int32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int32) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int32?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension Int64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int64) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Int64?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}

extension UInt8: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt8) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt8?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension UInt16: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt16) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt16?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension UInt32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt32) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt32?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension UInt64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt64) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: UInt64?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}

extension Float32: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Float) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Float?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension Float64: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Double) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Double?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}
extension Bool: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Bool) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Bool?) -> Int {
        return BinaryUtility.serialize(bytes, value)
    }
}

extension Date: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Date) -> Int {
        let timeSpan = TimeSpan(timeIntervalSince1970: value.timeIntervalSince1970)
        return TimeSpan.serialize(bytes, offset, timeSpan)
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: Date?) -> Int {
        var timeSpan: TimeSpan? = nil
        if let value = value {
            timeSpan = TimeSpan(timeIntervalSince1970: value.timeIntervalSince1970)
        }
        return TimeSpan.serialize(bytes, offset, timeSpan)
    }
}
extension String: PrimitiveSerializable {
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: String) -> Int {
        var byteSize = 0
        let utf8Data = value.data(using: .utf8)!
        byteSize += BinaryUtility.serialize(bytes, utf8Data.count) // length
        bytes.append(utf8Data)
        byteSize += utf8Data.count
        return byteSize
    }
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: String?) -> Int {
        if let value = value {
            return serialize(bytes, -1, value)
        } else {
            return BinaryUtility.serialize(bytes, -1) // length
        }
    }
}
