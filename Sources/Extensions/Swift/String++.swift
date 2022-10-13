//
// Created by Carson Rau on 3/1/22.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(Foundation)
public extension String {
    var isWhitespaceOnly: Bool {
        unicodeScalars.allSatisfy(
            CharacterSet.whitespacesAndNewlines.contains
        )
    }
}
#endif

public extension String {
    var bool: Bool? {
        switch lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}

public extension String {
    func capitalizingFirst() -> Self {
        prefix(1).uppercased() + .init(dropFirst())
    }
    mutating func capitalizeFirst() {
        self = capitalizingFirst()
    }
    func number(of character: Character) -> Int {
        lazy.filter { $0 == character }.count
    }
    func lowercasingFirst() -> Self {
        prefix(1).lowercased() + .init(dropFirst())
    }
    mutating func lowercaseFirst() {
        self = lowercasingFirst()
    }
    mutating func replaceSubstring(_ substring: Substring, with replacement: Self) {
        replaceSubrange(substring.bounds, with: replacement)
    }
    mutating func replace(substrings: [Substring], with string: Self) {
        replaceSubranges(substrings.lazy.map { $0.bounds }, with: substrings.lazy.map { _ in string })
    }
    mutating func replace<T: StringProtocol>(occurrencesOf target: T, with string: T) {
        self = replacingOccurrences(of: target, with: string, options: .literal, range: nil)
    }
    mutating func replace<T: StringProtocol>(firstOccurrenceOf target: T, with string: T) {
        guard let range = range(of: target, options: .literal) else { return }
        replaceSubrange(range, with: string)
    }
    mutating func remove(substrings: [Substring]) {
        replace(substrings: substrings, with: "")
    }
    func trim(prefix: Self, suffix: Self) -> Substring {
        if hasPrefix(prefix) && hasSuffix(suffix) {
            return dropFirst(prefix.count).dropLast(suffix.count)
        } else {
            return self[bounds]
        }
    }
    @_disfavoredOverload
    func trim(prefix: Self, suffix: Self) -> Self {
        .init(trim(prefix: prefix, suffix: suffix) as Substring)
    }
    func tabIndent(_ count: Int) -> Self {
        .init(repeatElement("\t", count: count)) + self
    }
    mutating func appendLine(_ string: Self) {
        self += (string + "\n")
    }
    mutating func appendTabIndentedLine(_ count: Int, _ string: Self) {
        appendLine(.init(repeatElement("\t", count: count)) + string)
    }
    func trimmingWhitespace() -> Self {
        trimmingCharacters(in: .whitespaces)
    }
    func splitInHalf(separator: Self) -> (Self, Self) {
        let range = range(of: separator, range: nil, locale: nil)
        if let range = range {
            let lhs = String(self[..<range.lowerBound])
            let rhs = String(self[range.upperBound...])
            return (lhs, rhs)
        }
        return (self, "")
    }
}
// MARK: - Substrings
public extension String {
    var numberOfLines: Int {
        var result = 0
        enumerateLines { (_, _) in
            result += 1
        }
        return result
    }
}
public extension String {
    subscript(firstSubstring substring: Self) -> Substring? {
        range(of: substring).map { self[$0] }
    }
}

public extension String {
    func contains(substring: Substring) -> Bool {
        substring.parent == self && bounds.contains(substring.bounds)
    }
    func contains(substring: Substring?) -> Bool {
        substring.map { contains(substring: $0) } ?? false
    }
    func dropFirst() -> Substring {
        dropFirst(1)
    }
    func dropLast() -> Substring {
        dropLast(1)
    }
    func dropPrefixIfPresent<String: StringProtocol>(_ prefix: String) -> Substring {
        hasPrefix(prefix) ? dropFirst(prefix.count) : .init(self)
    }
    @_disfavoredOverload
    func dropPrefixIfPresent<String: StringProtocol>(_ prefix: String) -> Self {
        Self(dropPrefixIfPresent(prefix) as Substring)
    }
    func dropSuffixIfPresent<String: StringProtocol>(_ suffix: String) -> Substring {
        hasSuffix(suffix) ? dropLast(suffix.count) : .init(self)
    }
    @_disfavoredOverload
    func dropSuffixIfPresent<String: StringProtocol>(_ suffix: String) -> Self {
        .init(dropSuffixIfPresent(suffix) as Substring)
    }
    func enumeratedLines() -> [String] {
        var result: [String] = []
        enumerateLines { line, _ in
            result += line
        }
        return result
    }
    func line(containingSubstring substring: Substring) -> Substring? {
        lines().find { $0.contains(substring: substring) }
    }
    func lines(omittingEmpty: Bool = false) -> [Substring] {
        split(omittingEmptySubsequences: false) { $0 == .newLine  }
    }
    func substrings(separatedBy separator: Character) -> [Substring] {
        split { $0 == separator }
    }
}
