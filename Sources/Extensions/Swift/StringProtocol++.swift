//
// Created by Carson Rau on 1/26/22.
//

#if canImport(Foundation)
    import Foundation
#endif
import Swift

public extension StringProtocol {
    func commonSuffix <T: StringProtocol>(
            with aString: T,
            options: String.CompareOptions = []
    ) -> String {
        String(Swift.zip(reversed(), aString.reversed())
                       .lazy
                        .prefix {
                            String($0.0).compare(String($0.1), options: options) == .orderedSame
                        }
                        .map { $0.0 }
                        .reversed()
        )
    }
    func escape(_ characterSet: [(character: String, escapedCharacter: String)]) -> String {
        var string = String(self)
        for val in characterSet {
            string = string.replacingOccurrences(of: val.character, with: val.escapedCharacter, options: .literal)
        }
        return string
    }
}
// MARK: - Foundation Extensions
#if canImport(Foundation)
    extension StringProtocol {
        public func replacingOccurrences <Input: StringProtocol, Output: StringProtocol>(
                ofPattern pattern: Input,
                withTemplate template: Output,
                options: String.CompareOptions = [.regularExpression],
                range searchRange: Range<Self.Index>? = nil
        ) -> String {
            assert(
                    options.isStrictSubset(of: [.regularExpression, .anchored, .caseInsensitive]),
                    "Invalid options for regular expression statement."
            )
            return replacingOccurrences(
                    of: pattern,
                    with: template,
                    options: options.union(.regularExpression),
                    range: searchRange
            )
        }
    }
#endif
