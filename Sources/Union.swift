//
//  Union.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/12/16.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public protocol Union {
    
    associatedtype UnionKey: Serializable

    var key: UnionKey { get }
    var value: Any { get }

    func serializeValue(_ bytes: NSMutableData, _ offset: Int) -> Int
    
    init(key: UnionKey, _ bytes: NSData, _ offset: Int, _ byteSize: inout Int)
    
}

public enum UnionSerializer {
    
    // MARK: - serialize
    
    public static func serialize<T: Union>(_ bytes: NSMutableData, _ offset: Int, _ union: T?) -> Int {
        let start = bytes.length
        var length = 0
        
        length += BinaryUtility.serialize(bytes, -1) // byteSize
        
        guard let union = union else {
            return length
        }
        
        length += T.UnionKey.serialize(bytes, -1, union.key)
        //length += T.UnionValue.serialize(bytes, -1, union.value)
        length += union.serializeValue(bytes, -1)
        
        _ = BinaryUtility.serialize(bytes, start, length - start) // byteSize
        
        return length
    }
    
    // MARK: - deserialize
    
    public static func deserialize<T: Union>(_ bytes: NSData, _ offset: Int, _ byteSize: inout Int) -> T? {
        let start = byteSize
        
        let size: Int = BinaryUtility.deserialize(bytes, offset + (byteSize - start), &byteSize)
        if size < 0 {
            return nil
        }
        
        let key: T.UnionKey = T.UnionKey.deserialize(bytes, offset + (byteSize - start), &byteSize)
        let union = T(key: key, bytes, offset + (byteSize - start), &byteSize)
        
        return union
    }
    
}
