//
//  Created by Carson Rau on 3/29/22.
//
#if canImport(UIKit)
import UIKit

// MARK: - Models
public enum HapticFeedbackStyle: Int {
    case light
    case medium
    case heavy
    case soft
    case rigid
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
    }
}

public enum HapticFeedbackType: Int {
    case success
    case warning
    case error
    var value: UINotificationFeedbackGenerator.FeedbackType {
        UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
    }
}

public enum Haptic {
    case impact(HapticFeedbackStyle)
    case notification(HapticFeedbackType)
    case selection
    
    public func generate() {
        switch self {
        case let .impact(style):
            let generator = UIImpactFeedbackGenerator(style: style.value)
            generator.prepare()
            generator.impactOccurred()
        case let .notification(type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type.value)
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    static let queue: OperationQueue = .serial
    
    public static func play(_ notes: [Note]) {
        guard queue.operations.isEmpty else { return }
        notes.forEach {
            if let last = queue.operations.last {
                $0.operation.addDependency(last)
            }
            queue.addOperation($0.operation)
        }
    }
    public static func play(_ pattern: String, delay: TimeInterval) {
        let notes = pattern.compactMap { Note($0, delay: delay) }
        play(notes)
    }
}

// MARK: - Custom Patterns
public enum Note {
    case haptic(Haptic)
    case wait(TimeInterval)
    
    init?(_ char: Character, delay: TimeInterval) {
        switch String(char) {
        case "O":
            self = .haptic(.impact(.heavy))
        case "o":
            self = .haptic(.impact(.medium))
        case ".":
            self = .haptic(.impact(.light))
        case "X":
            self = .haptic(.impact(.rigid))
        case "x":
            self = .haptic(.impact(.soft))
        case "-":
            self = .wait(delay)
        default:
            return nil
        }
    }
    var operation: Operation {
        switch self {
        case let .haptic(haptic):
            return HapticOperation(haptic)
        case let .wait(interval):
            return WaitOperation(interval)
        }
    }
}

internal final class HapticOperation: Operation {
    let haptic: Haptic
    init(_ haptic: Haptic) {
        self.haptic = haptic
    }
    override func main() {
        DispatchQueue.main.sync {
            self.haptic.generate()
        }
    }
}
internal final class WaitOperation: Operation {
    let duration: TimeInterval
    init(_ duration: TimeInterval) {
        self.duration = duration
    }
    override func main() {
        Thread.sleep(forTimeInterval: duration)
    }
}
#endif
