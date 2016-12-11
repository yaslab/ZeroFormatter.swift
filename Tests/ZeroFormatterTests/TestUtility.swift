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
