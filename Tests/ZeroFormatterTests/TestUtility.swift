//
//  TestUtility.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension NSData {
    
    func toArray() -> [UInt8] {
        return Array<UInt8>(Data(bytes: self.bytes, count: self.length))
    }
    
}

extension Collection where IndexDistance == Int, Iterator.Element == UInt8 {
    
    func toData() -> NSData {
        let buffer = malloc(count).assumingMemoryBound(to: UInt8.self)
        for (i, v) in self.enumerated() {
            buffer[i] = v
        }
        return NSData(bytesNoCopy: buffer, length: count, freeWhenDone: true)
    }
    
}
