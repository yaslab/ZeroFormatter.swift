//
//  ObjectBuilder.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/24.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

public class ObjectBuilder {
    
    private let data: NSMutableData
    private let offset: Int
    
    private var appendFunctions = [(() -> Void)]()
    
    internal init(_ data: NSMutableData) {
        self.data = data
        self.offset = data.length
    }
    
    private func begin() {
        let lastIndex = appendFunctions.count - 1
        
        let zero = Int32(0)
        // byteSize
        _serialize(data, zero)
        // lastIndex
        _serialize(data, Int32(lastIndex).littleEndian)
        // indexOffset
        for _ in 0 ... lastIndex {
            _serialize(data, zero)
        }
    }
    
    private func updateIndexOffset(_ index: Int) {
        let indexOffset = Int32(data.length)
        
        let p = data.mutableBytes + offset + 4 + 4 + (4 * index)
        p.assumingMemoryBound(to: Int32.self)[0] = indexOffset.littleEndian
    }
    
    private func end() {
        let byteSize = Int32(data.length - offset)

        let p = data.mutableBytes + offset
        p.assumingMemoryBound(to: Int32.self)[0] = byteSize.littleEndian
    }
    
    internal func build() -> Int {
        begin()
        for (i, appendFunction) in appendFunctions.enumerated() {
            updateIndexOffset(i)
            appendFunction()
        }
        end()
        
        return data.length - offset
    }
    
    // -----
    
    public func append<T: Serializable>(_ value: T) {
        appendFunctions.append({ [unowned self] in _ = T.serialize(self.data, 0, value) })
    }
    
    public func append<T: Serializable>(_ value: T?) {
        appendFunctions.append({ [unowned self] in _ = T.serialize(self.data, 0, value) })
    }
    
    public func append<T: Serializable>(_ values: Array<T>?) {
        appendFunctions.append({ [unowned self] in
            if let values = values {
                let length = Int32(values.count)
                _serialize(self.data, length.littleEndian)
                for value in values {
                    T.serialize(self.data, 0, value)
                }
            } else {
                let length = Int32(-1)
                _serialize(self.data, length.littleEndian)
            }
        })
    }

}
