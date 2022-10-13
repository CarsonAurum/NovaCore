//
// Created by Carson Rau on 3/4/22.
//

#if canImport(Foundation)
import Foundation
#endif

public extension Substring {
    init(consuming left: Substring, and right: Substring) {
        assert(left.parent == right.parent)
        assert(left.bounds <~= right.bounds)
        self = left.parent[left.bounds.lowerBound ..< right.bounds.upperBound]
    }
    init(across substrings: Substring...) {
        let parent = substrings.first!.parent
        assert {
            substrings.map { $0.parent }.allElementsAreEqual()
        }
        if let first = substrings.first, let last = substrings.last {
            self = parent[first.startIndex ..< last.endIndex]
        } else {
            self = parent[parent.startIndex...]
        }
    }
}

public extension Substring {
    func contains(substring: Substring) -> Bool {
        guard substring.parent == substring.parent else { return false }
        return bounds.contains(substring.bounds)
    }
    func contains(substring: Substring?) -> Bool {
        substring.map { contains(substring: $0) } ?? false
    }
    func components(separatedBy separator: Character) -> [Substring] {
        split { $0 == separator }
    }
    mutating func extend(upToAndInclusiveOf substring: Substring) {
        assert(parent.contains(substring: substring))
        if substring.bounds <~= bounds {
            self = parent[substring.bounds.lowerBound ..< bounds.upperBound]
        } else {
            self = parent[bounds.lowerBound ..< substring.bounds.upperBound]
        }
    }
    func firstLine() -> Substring {
        split(separator: "\n").first!
    }
    func lastLine() -> Substring {
        split(separator: "\n").last!
    }
    var parent: String {
        (-*>self as Slice<String>).base
    }
    mutating func replace(occurrencesOf target: String, with string: String) {
        self = Substring(replacingOccurrences(of: target, with: string, options: .literal, range: nil))
    }
    mutating func replace(firstOccurrenceOf target: String, with string: String) {
        guard let range = range(of: target, options: .literal) else { return }
        replaceSubrange(range, with: string)
    }
    func trimming(leading character: Character) -> Substring {
        guard !isEmpty else { return self }
        var idx = startIndex
        while idx != endIndex, self[idx] == character {
            idx = self.index(idx, offsetBy: 1)
        }
        return self[idx ..< endIndex]
    }
    func trimming(trailing character: Character) -> Substring {
        guard !isEmpty else { return self }
        var idx = lastIndex
        while containsIndex(idx), self[idx] == character {
            idx = self.index(idx, offsetBy: -1)
        }
        guard startIndex != idx else {
            return self[startIndex ..< self.index(startIndex, offsetBy: 1)]
        }
        return self[startIndex...idx]
    }
    #if canImport(Foundation)
    func trimmingLeadingCharacters(
            in characterSet: CharacterSet,
            maximum: Int? = nil
    ) -> Substring {
        if maximum == 0 { return self }
        guard !isEmpty else { return self }
        var idx = startIndex
        var count = 0
        while CharacterSet(charactersIn: String(self[idx])).isSubset(of: characterSet) {
            idx = self.index(idx, offsetBy: 1)
            count += 1
            if count == maximum {
                break
            }
            guard idx < endIndex, idx != endIndex else {
                break
            }
        }
        return self[idx ..< endIndex]
    }
    func trimmingTrailingCharacters(in characterSet: CharacterSet) -> Substring {
        guard !isEmpty else { return self }
        var idx = lastIndex
        while containsIndex(idx),
              CharacterSet(charactersIn: String(self[idx])).isSubset(of: characterSet) {
            idx = self.index(idx, offsetBy: -1)
        }
        guard startIndex != idx else {
            return self[startIndex ..< self.index(startIndex, offsetBy: 1)]
        }
        return self[startIndex...idx]
    }
    func trimmingCharacters(in characterSet: CharacterSet) -> Substring {
        trimmingLeadingCharacters(in: characterSet).trimmingTrailingCharacters(in: characterSet)
    }
    #endif
    func trimming(_ character: Character) -> Substring {
        trimming(leading: character).trimming(trailing: character)
    }
    func trimmingNewlines() -> Substring {
        trimming("\n")
    }
}
