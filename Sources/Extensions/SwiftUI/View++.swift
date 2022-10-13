//
//  Created by Carson Rau on 3/7/22.
//

#if canImport(SwiftUI)
import protocol SwiftUI.View
import struct SwiftUI.ViewBuilder

extension View {
    @ViewBuilder
    public func `if` <Content: View> (
        _ conditional: Bool,
        content: (Self) -> Content
    ) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
#endif
