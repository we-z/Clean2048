
import SwiftUI

struct TileBoardView: View {
    
    // MARK: - Properties
    
    typealias SupportingMatrix = TileMatrix<IdentifiedTile>
    
    let matrix: Self.SupportingMatrix
    let tileEdge: Edge
    
    var tileBoardSize: Int
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        Color.black
    }
    
    // MARK: - Conformacne to View protocol
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                
                ForEach(0..<tileBoardSize, id: \.self) { x in
                    ForEach(0..<tileBoardSize, id: \.self) { y in
                        createBlock(nil, at: (x, y), proxy: proxy)
                    }
                }
                ForEach(matrix.flatten(), id: \.tile.id) { item in
                    createBlock(item.tile, at: item.index, proxy: proxy)
                }
            }
            .frame(
                width: calculateFrameSize(proxy),
                height: calculateFrameSize(proxy), alignment: .center
            )
            .drawingGroup(opaque: false, colorMode: .linear)
            .center(in: .local, with: proxy)
        }
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
    }
    
    // MARK: - Methods
    
    func createBlock(
        _ block: IdentifiedTile?,
        at index: IndexedTile<IdentifiedTile>.Index,
        proxy: GeometryProxy
    ) -> some View {
        let blockView: TileView
        if let block = block {
            blockView = TileView(number: block.value)
        } else {
            blockView = TileView.empty()
        }
        
        let tileSpacing = calcualteTileSpacing(proxy)
        let blockSize = calculateTileSize(proxy, interTilePadding: tileSpacing)
        let frameSize = calculateFrameSize(proxy)
        
        let position = CGPoint(
            x: CGFloat(index.0) * (blockSize + tileSpacing) + blockSize / 2 + tileSpacing,
            y: CGFloat(index.1) * (blockSize + tileSpacing) + blockSize / 2 + tileSpacing
        )
        
        return blockView
            .frame(width: blockSize, height: blockSize, alignment: .center)
            .position(x: position.x, y: position.y)
            .transition(.blockGenerated(
                from: tileEdge,
                position: CGPoint(x: position.x, y: position.y),
                in: CGRect(x: 0, y: 0, width: frameSize, height: frameSize)
            ))
            .animation(
                .interpolatingSpring(stiffness: 800, damping: 200),
                value: position
            )
    }
    
    // MARK: - Private Methods
    
    private func calculateFrameSize(_ proxy: GeometryProxy) -> CGFloat {
        let maxSide = min(proxy.size.width, proxy.size.height)
        let paddingFactor = maxSide / 100
        
        return maxSide - (paddingFactor * 3)
    }
    
    private func calculateTileSize(_ proxy: GeometryProxy, interTilePadding: CGFloat = 12) -> CGFloat {
        let frameSize = calculateFrameSize(proxy)
        let boardSize = CGFloat(tileBoardSize)
        return (frameSize / boardSize) - (interTilePadding + interTilePadding / boardSize)
    }
    
    private func calcualteTileSpacing(_ proxy: GeometryProxy) -> CGFloat {
        let frameSize = calculateFrameSize(proxy)
        return (frameSize / 300) * 8 // for every 300 pixels have an 8 pixels of spacing between the tiles, which make equally proportial the overall tile board layout between different screen configurations
    }
    
}

#Preview {
    Group {
        CompositeView()
    }
}
