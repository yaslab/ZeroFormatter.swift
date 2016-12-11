//
//  TestUtility.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/12.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension NSData {
    
    convenience init(bytes: [UInt8]) {
        let p = malloc(bytes.count).assumingMemoryBound(to: UInt8.self)
        var bytes = bytes
        memcpy(p, &bytes, bytes.count)
        self.init(bytesNoCopy: p, length: bytes.count, freeWhenDone: true)
    }
    
    func toArray() -> [UInt8] {
        let p = bytes.assumingMemoryBound(to: UInt8.self)
        var array = [UInt8]()
        for i in 0 ..< length {
            array.append(p[i])
        }
        return array
    }

}
