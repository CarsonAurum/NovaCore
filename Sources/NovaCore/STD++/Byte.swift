//
// Created by Carson Rau on 3/25/22.
//

import struct Swift.UInt8
import struct Swift.Int
import struct Swift.UnsafePointer

/// A typealias for bytes as used in other C-based programming languages.
public typealias Byte = UInt8
/// A typealias for native word on this platform as used in other C-based programming languages.
public typealias NativeWord = Int
/// A typealias for an unsafe pointer to a native word on this platform as used in other C-based
/// programming languages.
public typealias NativeWordPointer = UnsafePointer<NativeWord>
