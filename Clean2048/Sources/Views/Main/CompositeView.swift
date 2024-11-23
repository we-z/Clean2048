
import SwiftUI
import Combine

let impactSoft = UIImpactFeedbackGenerator(style: .soft)

struct CompositeView: View {
    
    // MARK: - Proeprties
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @AppStorage("bestScore") var bestScore: Int = 0
    @State private var ignoreGesture = false
    @State private var hasGameEnded = false
    @State private var viewState = CGSize.zero
    
    @State private var sideMenuViewState = CGSize.zero
    @State private var presentSideMenu = false
    
    @ObservedObject private var logic: GameLogic
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State private var score: Int = 0 {
        didSet {
            if score > bestScore {
                bestScore = score
            }
        }
    }
    
    // MARK: - Initializers
    
    init() {
        self.logic = GameLogic(size: 4)
    }
    
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
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Best")
                        .bold()
                        .font(Font.system(.title))
                        .foregroundColor(.gray)
                    
                    Text("\(bestScore)")
                        .font(Font.system(.largeTitle).weight(.black))
                        .foregroundColor(.white)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        .id("Score \(self.bestScore)")
                    Spacer()
                    Text(hasGameEnded ? "Game Over" : "Score")
                        .bold()
                        .font(Font.system(.largeTitle))
                        .foregroundColor(.gray)
                    
                    Text("\(score)")
                        .font(Font.system(.largeTitle).weight(.black))
                        .foregroundColor(.white)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        .id("Score \(self.score)")
                    
                    Spacer()
                    Button {
                        impactSoft.impactOccurred()
                        resetGame()
                    } label: {
                        Text("New Game")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal)
                            .background{
                                Color.white
                                    .opacity(0.1)
                            }
                            .cornerRadius(6)
                    }
                    TileBoardView(matrix: logic.tiles,
                                  tileEdge: logic.lastGestureDirection.invertedEdge,
                                  tileBoardSize: logic.boardSize)
                    .onReceive(logic.$score) { (publishedScore) in
                        score = publishedScore
                    }
                }
                .onReceive(logic.$noPossibleMove) { (publisher) in
                    let hasGameEnded = logic.noPossibleMove
                    self.hasGameEnded = hasGameEnded
                }
            }
            .gesture(gesture, including: .all)
    }
    
    private func resetGame() {
        hasGameEnded = false
        logic.reset()
    }
}

// MARK: - Previews


#Preview {
    Group {
        CompositeView()
    }
}
