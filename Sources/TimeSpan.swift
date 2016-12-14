//
//  TimeSpan.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/15.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

struct TimeSpan: Serializable, Deserializable {
    
    let timeIntervalSince1970: TimeInterval
    
    static var length: Int? {
        return 12
    }

    static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: TimeSpan) -> Int {
        let unixTime = value.timeIntervalSince1970
        let seconds = Int64(unixTime)
        let nanos = Int32((abs(unixTime) - floor(abs(unixTime))) * 1_000_000_000)
        var byteSize = 0
        byteSize += BinaryUtility.serialize(bytes, seconds)
        byteSize += BinaryUtility.serialize(bytes, nanos)
        return byteSize
    }
    
    static func serialize(_ bytes: NSMutableData, _ offset: Int, _ value: TimeSpan?) -> Int {
        var byteSize = 0
        if let value = value {
            byteSize += BinaryUtility.serialize(bytes, true)
            byteSize += serialize(bytes, -1, value)
        } else {
            byteSize += BinaryUtility.serialize(bytes, false)
            byteSize += BinaryUtility.serialize(bytes, Int64(0)) // seconds
            byteSize += BinaryUtility.serialize(bytes, Int32(0)) // nanos
        }
        return byteSize
    }
    
    static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> TimeSpan {
        let start = byteSize
        let seconds: Int64 = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        let nanos: Int32 = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        var unixTime = TimeInterval(seconds)
        unixTime += TimeInterval(nanos) / 1_000_000_000.0
        return TimeSpan(timeIntervalSince1970: unixTime)
    }
    
    static func deserialize(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> TimeSpan? {
        let start = byteSize
        let hasValue: Bool = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if hasValue {
            let value: TimeSpan = deserialize(bytes, offset + (byteSize - start), &byteSize)
            return value
        } else {
            return nil
        }
    }
    
}
