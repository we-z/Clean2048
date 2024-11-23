
import SwiftUI

struct TileView: View {
    
    // MARK: - Properties
    
    @Environment(\.tileColorTheme) private var tileColorTheme: TileColorTheme
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State var scale = 0.1
    @State var color: Color = .clear
    private var backgroundColor: Color {
        Color.gray.opacity(0.03)
    }
    
    private let number: Int?
    private let textId: String
    private let fontProportionalWidth: CGFloat = 3
        
    // MARK: - Initialziers
    
    init(number: Int) {
        self.number = number
        textId = "\(number)"
    }
    
    private init() {
        number = nil
        textId = ""
    }
    
    // MARK: - Static Methods
    
    static func empty() -> Self {
        return self.init()
    }
    
    // MARK: - Conformance to View protocol
    
    var body: some View {
        let tileColorTheme = self.tileColorTheme.colorPair(for: number, colorScheme, defaultColor: self.backgroundColor)
        
        return GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .fill(tileColorTheme.background)
                    .overlay(color)
                
                Text(title())
                    .font(.system(size: fontSize(proxy)))
                    .id(number)
                    .foregroundColor(tileColorTheme.font)
                    .transition(AnyTransition.scale(scale: 0.2).combined(with: .opacity).animation(.modalSpring(duration: 0.3)))
            }
            .zIndex(Double.greatestFiniteMagnitude)
            .clipped()
            .cornerRadius(proxy.size.width / 9)
            .scaleEffect((number != nil) ? scale : 1)
            .animation(
                .linear(duration: 0.1),
                value: scale
            )
            .animation(
                .linear(duration: 0.1),
                value: color
            )
            .onAppear{
                scale = 1.0
            }
            .onChange(of: number) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    color = .blue
                    scale = 1.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        color = .clear
                        scale = 1.0
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func title() -> String {
        guard let number = self.number else {
            return ""
        }
        return String(number)
    }
    
    private func fontSize(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.width / fontProportionalWidth
    }
}

#Preview {
    CompositeView()
}
