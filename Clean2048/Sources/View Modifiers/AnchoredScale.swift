

import SwiftUI

struct AnchoredScale: ViewModifier {
    let scaleFactor: CGFloat
    let anchor: UnitPoint

    func body(content: Self.Content) -> some View {
        content.scaleEffect(scaleFactor, anchor: anchor)
    }
}
