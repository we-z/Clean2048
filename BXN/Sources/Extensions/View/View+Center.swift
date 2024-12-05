
import SwiftUI

extension View {
    func center(in coordinateSpace: CoordinateSpace, with proxy: GeometryProxy) -> some View {
        let frame = proxy.frame(in: coordinateSpace)
        return position(x: frame.midX, y: frame.midY)
    }
}

extension View {

    func prefersPersistentSystemOverlaysHidden() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.persistentSystemOverlays(.hidden)
        } else {
            return self
        }
    }
}
