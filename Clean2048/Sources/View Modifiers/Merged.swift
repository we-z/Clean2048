
import SwiftUI

struct Merged<M1, M2>: ViewModifier where M1: ViewModifier, M2: ViewModifier {
    let m1: M1
    let m2: M2

    init(first: M1, second: M2) {
        m1 = first
        m2 = second
    }

    func body(content: Self.Content) -> some View {
        content.modifier(m1).modifier(m2)
    }
}
