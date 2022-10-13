//
// Created by Carson Rau on 1/31/22.
//

// MARK: - Static Extensions
extension Character {
    /// Static access to a new-line character.
    public static var newLine: Character { "\n" }
    /// Statically generate a random alphanumeric character.
    public static func random() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
// MARK: - Properties
extension Character {
    public var asciiValue: UInt32 {
        get {
            let s = String(self).unicodeScalars
            return s[s.startIndex].value
        }
    }
    /// Integer from character (if applicable).
    public var int: Int? {
        Int(String(self))
    }
    /// Check if a character is an emoji.
    public var isEmoji: Bool {
        switch String(self).unicodeScalars.first!.value {
        case 0x1F600...0x1F64F,         // Emoticons
             0x1F300...0x1F5FF,         // Misc Symbols and Pictographs
             0x1F680...0x1F6FF,         // Transport and Map
             0x1F1E6...0x1F1FF,         // Regional country flags
             0x2600...0x26FF,           // Misc symbols
             0x2700...0x27BF,           // Dingbats
             0xE0020...0xE007F,         // Tags
             0xFE00...0xFE0F,           // Variation Selectors
             0x1F900...0x1F9FF,         // Supplemental Symbols and Pictographs
             127_000...127_600,         // Various asian characters
             65024...65039,             // Variation selector
             9100...9300,               // Misc items
             8400...8447:               // Combining Diacritical Marks for Symbols
            return true
        default:
            return false
        }
    }
    /// Access the lowercased version of this character.
    public var lowercased: Character {
        String(self).lowercased().first!
    }
    /// String from character.
    public var string: String {
        String(self)
    }
    /// Access the uppercased version of this character.
    public var uppercased: Character {
        String(self).uppercased().first!
    }
    
}

// MARK: - Operators
extension Character {
    /// Repeat a character multiple times.
    /// - Parameters:
    ///   - lhs: Character to repeat
    ///   - rhs: Number of times to repeat character.
    /// - Returns: String with character repeated `n` times.
    public static func * (lhs: Character, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }
    /// Repeat a character multiple times.
    /// - Parameters:
    ///   - lhs: Number of times to repeat character.
    ///   - rhs: Character to repeat
    /// - Returns: String with character repeated `n` times.
    public static func * (lhs: Int, rhs: Character) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}
