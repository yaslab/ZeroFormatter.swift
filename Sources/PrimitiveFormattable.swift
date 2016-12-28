//
//  PrimitiveFormattable.swift
//  ZeroFormatter
//
//  Created by Yasuhiro Hatta on 2016/11/30.
//  Copyright © 2016 yaslab. All rights reserved.
//

import Foundation

extension Int8: Formattable {
    public static var length: Int? { return 1 }
}
extension Int16: Formattable {
    public static var length: Int? { return 2 }
}
extension Int32: Formattable {
    public static var length: Int? { return 4 }
}
extension Int64: Formattable {
    public static var length: Int? { return 8 }
}

extension UInt8: Formattable {
    public static var length: Int? { return 1 }
}
extension UInt16: Formattable {
    public static var length: Int? { return 2 }
}
extension UInt32: Formattable {
    public static var length: Int? { return 4 }
}
extension UInt64: Formattable {
    public static var length: Int? { return 8 }
}

extension Float: Formattable {
    public static var length: Int? { return 4 }
}
extension Double: Formattable {
    public static var length: Int? { return 8 }
}
extension Bool: Formattable {
    public static var length: Int? { return 1 }
}

extension Date: Formattable {
    public static var length: Int? { return TimeSpan.length }
}
extension String: Formattable {
    public static var length: Int? { return nil }
}
