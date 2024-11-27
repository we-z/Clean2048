
import SwiftUI
import Combine

let impactLight = UIImpactFeedbackGenerator(style: .light)

struct CompositeView: View {
    
    // MARK: - Proeprties
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State private var ignoreGesture = false
    
    @State private var viewState = CGSize.zero
    
    @State private var sideMenuViewState = CGSize.zero
    @State private var presentSideMenu = false
    
    
    @ObservedObject private var logic: GameLogic = GameLogic.shared
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: - Drag Gesture
    
    private var gesture: some Gesture {
        let threshold: CGFloat = 25
        
        let drag = DragGesture()
            .onChanged { v in
                guard !ignoreGesture else { return }
                
                guard abs(v.translation.width) > threshold ||
                    abs(v.translation.height) > threshold else {
                        return
                }
                withTransaction(Transaction()) {
                    ignoreGesture = true
                    
                    if v.translation.width > threshold {
                        // Move right
                        logic.move(.right)
                    } else if v.translation.width < -threshold {
                        // Move left
                        logic.move(.left)
                    } else if v.translation.height > threshold {
                        // Move down
                        logic.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        logic.move(.up)
                    }
                }
        }
        .onEnded { _ in
            ignoreGesture = false
        }
        return drag
    }
    
    // MARK: - Comformance to View protocol
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                if proxy.size.width < proxy.size.height {
                    VStack {
                        HeaderView()
                        TileBoardView(matrix: logic.tiles,
                                      tileEdge: logic.lastGestureDirection.invertedEdge,
                                      tileBoardSize: logic.boardSize)
                    }
                } else {
                    HStack{
                        HeaderView()
                        TileBoardView(matrix: logic.tiles,
                                      tileEdge: logic.lastGestureDirection.invertedEdge,
                                      tileBoardSize: logic.boardSize)
                    }
                }
                
            }
            .gesture(gesture, including: .all)
        }
    }
}

// MARK: - Previews


#Preview {
    Group {
        CompositeView()
    }
}
