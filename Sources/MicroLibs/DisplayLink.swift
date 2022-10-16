//
//  Created by Carson Rau on 2/26/22.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(Combine)
import Combine
#endif

#if os(iOS) || os(tvOS)
import QuartzCore
#elseif os(macOS)
import CoreVideo
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif


// MARK: - DisplayLink
public final class DisplayLink: Publisher {
    public static let shared = DisplayLink()
    public convenience init() {
        self.init(platformDisplayLink: PlatformDisplayLink())
    }
    // MARK: Types
    public struct Frame {
        public var timestamp: TimeInterval
        public var duration: TimeInterval
    }
    fileprivate final class Subscription: Combine.Subscription {
        var onCancel: () -> Void
        init(onCancel: @escaping () -> Void) {
            self.onCancel  = onCancel
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            onCancel()
        }
    }
    // MARK: Publisher
    public typealias Output =  Frame
    public typealias Failure = Never
    private var subscribers: [CombineIdentifier:AnySubscriber<Frame, Never>] = [:] {
        didSet {
            dispatchPrecondition(condition: .onQueue(.main))
            platformDisplayLink.isPaused = subscribers.isEmpty
        }
    }
    public func receive<Input>(subscriber: Input) where Input : Subscriber, Never == Input.Failure, Frame == Input.Input {
        dispatchPrecondition(condition: .onQueue(.main))
        let erased = AnySubscriber(subscriber)
        let id = erased.combineIdentifier
        let subscription = Subscription { [weak self] in
            self?.cancelSubscription(for: id)
        }
        subscribers[id] = erased
        subscriber.receive(subscription: subscription)
    }
    // MARK: Internal
    private let platformDisplayLink: PlatformDisplayLink
    fileprivate init(platformDisplayLink: PlatformDisplayLink) {
        dispatchPrecondition(condition: .onQueue(.main))
        self.platformDisplayLink = platformDisplayLink
        self.platformDisplayLink.onFrame = { [weak self] frame in
            self?.send(frame: frame)
        }
    }
    private func cancelSubscription(for identifier: CombineIdentifier) {
        dispatchPrecondition(condition: .onQueue(.main))
        subscribers.removeValue(forKey: identifier)
    }
    private func send(frame: Frame) {
        dispatchPrecondition(condition: .onQueue(.main))
        let subscribers = self.subscribers.values
        subscribers.forEach { _ = $0.receive(frame) }
    }
}


// MARK: - PlatformLink

#if os(iOS) || os(tvOS)

extension DisplayLink {
    fileprivate final class PlatformDisplayLink {
        var onFrame: ((Frame) -> Void)? = nil
        let displayLink: CADisplayLink
        let target = DisplayLinkTarget()
        var isPaused: Bool {
            get { displayLink.isPaused }
            set { displayLink.isPaused = newValue }
        }
        init() {
            displayLink = CADisplayLink(target: target, selector: #selector(DisplayLinkTarget.frame(_:)))
            displayLink.isPaused = true
            displayLink.add(to: .main, forMode: .common)
            target.callback = { [unowned self] in self.onFrame?($0) }
        }
        deinit {
            displayLink.invalidate()
        }
        final class DisplayLinkTarget {
            var callback: ((DisplayLink.Frame) -> Void)? = nil
            @objc dynamic func frame(_ displayLink: CADisplayLink) {
                callback?(Frame(timestamp: displayLink.timestamp, duration: displayLink.duration))
            }
        }
    }
}

#elseif os(macOS)

extension DisplayLink {
    fileprivate final class PlatformDisplayLink {
        var onFrame: ((Frame) -> Void)? = nil
        var displayLink: CVDisplayLink = {
            var dl: CVDisplayLink? = nil
            CVDisplayLinkCreateWithActiveCGDisplays(&dl)
            return dl!
        }()
        var isPaused: Bool = true {
            didSet {
                guard isPaused != oldValue else { return }
                if isPaused == true {
                    CVDisplayLinkStop(self.displayLink)
                } else {
                    CVDisplayLinkStart(self.displayLink)
                }
            }
        }
        init() {
            CVDisplayLinkSetOutputHandler(self.displayLink) {
                [weak self] _, currentTime, outputTime, _, _ in
                let frame = Frame(
                    timestamp: currentTime.pointee.timeInterval,
                    duration: outputTime.pointee.timeInterval - currentTime.pointee.timeInterval
                )
                DispatchQueue.main.async {
                    self?.handle(frame: frame)
                }
                return kCVReturnSuccess
            }
        }
        deinit {
            isPaused = true
        }
        func handle(frame: Frame) {
            guard isPaused == false else { return }
            onFrame?(frame)
        }
    }
}

extension CVTimeStamp {
    fileprivate var timeInterval: TimeInterval { TimeInterval(videoTime) / TimeInterval(self.videoTimeScale) }
}

#else
#endif

// MARK: - SwiftUI

#if canImport(SwiftUI)
extension View {
    public func onFrame(
        isActive: Bool = true,
        displayLink: DisplayLink = .shared,
        _ action: @escaping (DisplayLink.Frame) -> Void
    ) -> some View {
        let publisher = isActive ?
                displayLink.eraseToAnyPublisher() : Empty<DisplayLink.Frame, Never>().eraseToAnyPublisher()
        return SubscriptionView(content: self, publisher: publisher, action: action)
    }
}
#endif
