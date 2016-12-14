# ZeroFormatter.swift

[![Build Status](https://travis-ci.org/yaslab/ZeroFormatter.swift.svg?branch=master)](https://travis-ci.org/yaslab/ZeroFormatter.swift)

Implementation of [ZeroFormatter](https://github.com/neuecc/ZeroFormatter) in Swift.

## How to use

```
// TODO: Sample Code
// ...
```

## Supported types (Stage1 only)

### Primitive Format

| Implemented | Swift type | C# type |
| ---- | ---- | ---- |
| o | `Int8` | `SByte` |
| o | `Int16` | ← |
| o | `Int32` | ← |
| o | `Int64` | ← |
| o | `UInt8` | `Byte` |
| o | `UInt16` | ← and `Char` |
| o | `UInt32` | ← |
| o | `UInt64` | ← |
| o | `Float` | `Single` |
| o | `Double` | ← |
| o | `Bool` | `Boolean` |
| o | `TimeSpan` | `TimeSpan` |
| o | `Date` | `DateTime` |
| | TBD | `DateTimeOffset` |
| o | `String` | ← |

### Primitive Format (Optional)

| Implemented | Swift type | C# type |
| ---- | ---- | ---- |
| o | `Int8?` | `SByte?` |
| o | `Int16?` | ← |
| o | `Int32?` | ← |
| o | `Int64?` | ← |
| o | `UInt8?` | `Byte?` |
| o | `UInt16?` | ← and `Char?` |
| o | `UInt32?` | ← |
| o | `UInt64?` | ← |
| o | `Float?` | `Single?` |
| o | `Double?` | ← |
| o | `Bool?` | `Boolean?` |
| o | `TimeSpan?` | `TimeSpan?` |
| o | `Date?` | `DateTime?` |
| | TBD | `DateTimeOffset?` |
| o | `String?` | ← |

### Sequence Format

| Implemented | Swift type | C# type | Note |
| ---- | ---- | ---- | ---- |
| o | `Array<T>?` | `Sequence<T>` | if length = -1, indicates null |

### List Format

| Implemented | Swift type | C# type | Note |
| ---- | ---- | ---- | ---- |
| o | `FixedSizeList<T>?` | `FixedSizeList` | if length = -1, indicates null |
| o | `VariableSizeList<T>?` | `VariableSizeList` | if byteSize = -1, indicates null |

### Object Format

| Implemented | Swift type | C# type | Note |
| ---- | ---- | ---- | ---- |
| o | `ObjectSerializable?` | `Object` | if byteSize = -1, indicates null |
| o | `StructSerializable` | `Struct` | |
| o | `StructSerializable?` | `Struct?` | |

### Union Format

| Implemented | Swift type | C# type | Note |
| ---- | ---- | ---- | ---- |
| | TBD | `Union` | if byteSize = -1, indicates null |
