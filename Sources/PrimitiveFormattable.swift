//
//  PrimitiveFormattable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/30.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension Int8: ZeroFormattable {
    public static var length: Int? { return 1 }
}
extension Int16: ZeroFormattable {
    public static var length: Int? { return 2 }
}
extension Int32: ZeroFormattable {
    public static var length: Int? { return 4 }
}
extension Int64: ZeroFormattable {
    public static var length: Int? { return 8 }
}

extension UInt8: ZeroFormattable {
    public static var length: Int? { return 1 }
}
extension UInt16: ZeroFormattable {
    public static var length: Int? { return 2 }
}
extension UInt32: ZeroFormattable {
    public static var length: Int? { return 4 }
}
extension UInt64: ZeroFormattable {
    public static var length: Int? { return 8 }
}

extension Float: ZeroFormattable {
    public static var length: Int? { return 4 }
}
extension Double: ZeroFormattable {
    public static var length: Int? { return 8 }
}
extension Bool: ZeroFormattable {
    public static var length: Int? { return 1 }
}

extension Date: ZeroFormattable {
    public static var length: Int? { return 12 }
}
extension String: ZeroFormattable {
    public static var length: Int? { return nil }
}
