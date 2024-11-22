
import SwiftUI

public extension Animation {
    static var modalSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: 0)
    }

    static func modalSpring(duration: Double) -> Animation {
        .spring(response: 0.5, dampingFraction: 0.777, blendDuration: duration)
    }
}
