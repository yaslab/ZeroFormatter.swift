//
//  DateTimeOffset.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/15.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public struct DateTimeOffset: Serializable {

    public let timeIntervalSince1970: TimeInterval
    public let secondsFromGMT: Int
    
    public private(set) lazy var date: Date = {
        return Date(timeIntervalSince1970: self.timeIntervalSince1970)
    }()
    
    public private(set) lazy var timeZone: TimeZone? = {
        return TimeZone(secondsFromGMT: self.secondsFromGMT)
    }()
    
    public init(timeIntervalSince1970: TimeInterval, secondsFromGMT: Int) {
        self.timeIntervalSince1970 = timeIntervalSince1970
        self.secondsFromGMT = secondsFromGMT
    }
    
    // MARK: - ZeroFormattable
    
    public static var length: Int? {
        return 14
    }
    
    // MARK: - Serializable
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: DateTimeOffset) -> Int {
        let timeSpan = TimeSpan(totalSeconds: value.timeIntervalSince1970)
        let offsetMinutes = Int16(value.secondsFromGMT / 60)
        
        var byteSize = 0
        byteSize += TimeSpan.serialize(bytes, -1, timeSpan)
        byteSize += BinaryUtility.serialize(bytes, offsetMinutes)
        return byteSize
    }
    
    public static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: DateTimeOffset?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += BinaryUtility.serialize(bytes, true)
            byteSize += serialize(bytes, -1, value)
        } else {
            byteSize += BinaryUtility.serialize(bytes, false)
            byteSize += BinaryUtility.serialize(bytes, Int64(0)) // seconds
            byteSize += BinaryUtility.serialize(bytes, Int32(0)) // nanos
            byteSize += BinaryUtility.serialize(bytes, Int16(0)) // offsetMinutes
        }
        return byteSize
    }
    
    // MARK: - Deserializable
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> DateTimeOffset {
        let start = byteSize
        let timeSpan: TimeSpan = TimeSpan.deserialize(bytes, offset + (byteSize - start), &byteSize)
        let offsetMinutes: Int16 = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        
        return DateTimeOffset(
            timeIntervalSince1970: timeSpan.totalSeconds,
            secondsFromGMT: Int(offsetMinutes) * 60
        )
    }
    
    public static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> DateTimeOffset? {
        let start = byteSize
        let hasValue: Bool = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: DateTimeOffset = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
}
