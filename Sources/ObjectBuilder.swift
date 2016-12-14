//
//  ObjectBuilder.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class ObjectBuilder {
    
    private let bytes: NSMutableData
    private let offset: Int
    
    private var functions = [(() -> Void)]()
    
    internal init(_ bytes: NSMutableData) {
        self.bytes = bytes
        self.offset = bytes.length
    }
    
    var byteSize: Int {
        return bytes.length - offset
    }
    
    private func begin() {
        // byteSize
        _ = BinaryUtility.serialize(bytes, 0)
        // lastIndex
        _ = BinaryUtility.serialize(bytes, functions.count - 1)
        // indexOffset
        for _ in 0 ..< functions.count {
            _ = BinaryUtility.serialize(bytes, 0)
        }
    }
    
    private func updateIndexOffset(_ index: Int) {
        let indexOffset = bytes.length
        _ = BinaryUtility.serialize(bytes, offset + 4 + 4 + (4 * index), indexOffset)
    }
    
    private func end() {
        _ = BinaryUtility.serialize(bytes, offset, byteSize)
    }
    
    internal func build() -> Int {
        begin()
        for (i, function) in functions.enumerated() {
            updateIndexOffset(i)
            function()
        }
        end()
        return byteSize
    }
    
    // -----
    
    public func append<T: Serializable>(_ value: T) {
        functions.append({ [unowned self] in _ = T.serialize(self.bytes, -1, value) })
    }
    
    public func append<T: Serializable>(_ value: T?) {
        functions.append({ [unowned self] in _ = T.serialize(self.bytes, -1, value) })
    }
    
    public func append<T: Serializable>(_ value: Array<T>?) {
        functions.append({ [unowned self] in _ = ArraySerializer.serialize(self.bytes, -1, value) })
    }

}
