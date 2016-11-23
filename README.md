# ZeroFormatter.swift

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
| o | Int8 | SByte |
| o | Int16 | ← |
| o | Int32 | ← |
| o | Int64 | ← |
| o | UInt8 | Byte |
| o | UInt16 | ←<br />Char |
| o | UInt32 | ← |
| o | UInt64 | ← |
| o | Float | Single |
| o | Double | ← |
| o | Bool | Boolean |
| | TimeInterval | TimeSpan |
| o | Date | DateTime |
| | TBD | DateTimeOffset |
| o | String | ← |

### Primitive Format (Optional)

| Implemented | Swift | C# |
| ---- | ---- | ---- |
| o | Int8? | SByte? |
| o | Int16? | ←<br />Char? |
| o | Int32? | ← |
| o | Int64? | ← |
| o | UInt8? | Byte? |
| o | UInt16? | ← |
| o | UInt32? | ← |
| o | UInt64? | ← |
| o | Float? | Single? |
| o | Double? | ← |
| o | Bool? | Boolean? |
| | TimeInterval? | TimeSpan? |
| o | Date? | DateTime? |
| | TBD? | DateTimeOffset? |
| o | String? | ← |

### Sequence Format

| Implemented | Swift | C# | Note |
| ---- | ---- | ---- | ---- |
| | Array<T> | Sequence<T> | |
| | Array<T>? | Sequence<T> | length = -1 |

### List Format

| Implemented | Swift | C# | Note |
| ---- | ---- | ---- | ---- |
| | Array<T> | FixedSizeList | |
| | Array<T>? | FixedSizeList | length = -1 |
| | Array<Any> | VariableSizeList | |
| | Array<Any>? | VariableSizeList | length = -1 |

### Object Format

| Implemented | Swift | C# | Note |
| ---- | ---- | ---- | ---- |
| | Serializable | Object | |
| | Serializable? | Object | length = -1 |
| | TBD | Struct | |
| | TBD? | Struct? | |

### Union Format

| Implemented | Swift | C# |
| ---- | ---- | ---- |
| | TBD | Union |
| | TBD? | Union |
