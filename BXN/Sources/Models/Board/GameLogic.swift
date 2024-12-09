
import SwiftUI
import Combine

let hapticManager = HapticManager.instance

final class GameLogic: ObservableObject {

    // MARK: - Conformance to ObservableObject protocol
    
    var objectWillChange = PassthroughSubject<GameLogic, Never>()
        
    // MARK: - Typealiases
    
    typealias TileMatrixType = TileMatrix<IdentifiedTile>
    
    // MARK: - Published Properties
    
    @Published private(set) var noPossibleMove: Bool = false
    @Published private(set) var score: Int = 0
    @Published private(set) var boardSize: Int
    @Published private(set) var hasMoveMergedTiles: Bool = false
    
    private(set) var lastGestureDirection: Direction = .up

    private var instanceId = 0
    private var mutableInstanceId: Int {
        instanceId += 1
        return instanceId
    }
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var tileMatrix: TileMatrixType!
    
    var tiles: TileMatrixType {
        return tileMatrix
    }

    // MARK: - Initializers
    
    static let shared = GameLogic()
    
    init() {
        boardSize = 3
        reset(boardSize: boardSize)
    }
    
    func reset() {
        reset(boardSize: boardSize)
    }
    
    func resetLastGestureDirection() {
        lastGestureDirection = .up
        objectWillChange.send(self)
    }
    
    enum State {
        case moved
        case merged
        case none
    }
    
    @discardableResult
    func move(_ direction: Direction) -> State {
        let previousMatrixSnapshot = tileMatrix!
        let previousScore = score
        
        defer { objectWillChange.send(self) }
        defer { OperationQueue.main.addOperation { self.resetLastGestureDirection() } }
        
        lastGestureDirection = direction

        var moved = false
        var hasMergedBlocks: Bool = false

        let axis = direction == .left || direction == .right

        for row in 0..<boardSize {
            var rowSnapshot = [IdentifiedTile?]()
            var compactRow = [IdentifiedTile]()
           
            computeIntermediateSnapshot(
                &rowSnapshot,
                &compactRow,
                axis: axis,
                currentRow: row
            )
            
            if merge(blocks: &compactRow, reverse: direction == .down || direction == .right) {
                hasMergedBlocks = true
            }
            
            var newRow = [IdentifiedTile?]()
            compactRow.forEach { newRow.append($0) }

            if compactRow.count < boardSize {
                nilout(rowCount: newRow.count, direction: direction, row: &newRow)
            }

            newRow.enumerated().forEach {
                if rowSnapshot[$0]?.value != $1?.value {
                    moved = true
                }
                tileMatrix.add($1, to: axis ? ($0, row) : (row, $0))
            }
        }
        let result = finalizeMove(previousMatrixSnapshot, hasMoved: moved, hasMergedBlocks: hasMergedBlocks, previousScore: previousScore)

        return result
    }
    
    func undo() {
        guard let lastState = previousStates.popLast() else {
            return
        }
        self.tileMatrix = lastState.tileMatrix
        self.score = lastState.score
        self.objectWillChange.send(self)
    }
    
    // MARK: - Private Methods
    
    private struct GameState {
        var tileMatrix: TileMatrix<IdentifiedTile>
        var score: Int
    }

    private var previousStates: [GameState] = []

    var canUndo: Bool {
        return !previousStates.isEmpty
    }
    
    private func computeIntermediateSnapshot(
        _ rowSnapshot: inout [IdentifiedTile?],
        _ compactRow: inout [IdentifiedTile],
        axis: Bool,
        currentRow row: Int
    ) {
        for col in 0..<boardSize {
            if let block = tileMatrix[axis ? (col, row) : (row, col)] {
                rowSnapshot.append(block)
                compactRow.append(block)
            } else {
                rowSnapshot.append(nil)
            }
        }
    }
    
    private func nilout(rowCount: Int, direction: Direction, row: inout [IdentifiedTile?]) {
        for _ in 0..<(boardSize - rowCount) {
            if direction == .left || direction == .up {
                row.append(nil)
            } else {
                row.insert(nil, at: 0)
            }
        }
    }
    
    private func finalizeMove(_ previousMatrixSnapshot: TileMatrixType, hasMoved moved: Bool, hasMergedBlocks: Bool, previousScore: Int) -> State {
        let areEqual = previousMatrixSnapshot.equals(to: tileMatrix)
        
        var result: State = .none
        
        if moved && !areEqual {
            result = hasMergedBlocks ? .merged : .moved
            
            // Save the previous state before generating a new tile
            let currentState = GameState(tileMatrix: previousMatrixSnapshot, score: previousScore)
            previousStates.append(currentState)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.025 * TimeInterval(self.boardSize)) {
                self.generateBlocks(generator: .single)
                self.hasMoveMergedTiles = hasMergedBlocks
                if hasMergedBlocks {
                    hapticManager.notification(type: .success)
                }
                
                // Check if moves are possible after generating the tile
                self.checkForPossibleMoves()
            }
        } else {
            // If no move happened, still check for possible moves
            self.checkForPossibleMoves()
        }
        return result
    }

    // Check if any move is possible after each state change
    private func checkForPossibleMoves() {
        DispatchQueue.main.async {
            self.noPossibleMove = !self.tileMatrix.isMovePossible()
            if self.noPossibleMove {
                print("No possible moves left!")
            }
            self.objectWillChange.send(self)
        }
    }

    // Merging rules:
    // 1 + 1 = 2
    // 2 + 2 = 3
    // 3 + 3 = 1
    private func merge(blocks: inout [IdentifiedTile], reverse: Bool) -> Bool {
        var hasMerged: Bool = false
        if reverse {
            blocks = blocks.reversed()
        }
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, IdentifiedTile)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.value == item.1.value {
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    let oldValue = mergedBlock.value
                    
                    // Determine new value after merge
                    // 1 -> merge into 2
                    // 2 -> merge into 3
                    // 3 -> merge into 1
                    let newValue: Int
                    switch oldValue {
                    case 1:
                        newValue = 2
                    case 2:
                        newValue = 3
                    case 3:
                        newValue = 4
                    case 4:
                        newValue = 5
                    case 5:
                        newValue = 1
                    default:
                        newValue = oldValue
                    }
                    
                    mergedBlock.value = newValue
                    
                    accPrefix.append((true, mergedBlock))
                    
//                    self.mergeMultiplier += self.mergeMultiplierStep
                    self.score += oldValue
                    hasMerged = true
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
            }
            .map { $0.1 }
        
        if reverse {
            blocks = blocks.reversed()
        }
        return hasMerged
    }
    
    private func reset(boardSize: Int) {
        self.boardSize = boardSize
        tileMatrix = TileMatrixType(size: boardSize)
        resetLastGestureDirection()
        generateBlocks(generator: .double)
        score = 0
        previousStates.removeAll()
        noPossibleMove = false
        
        // Save the initial state
        let initialState = GameState(tileMatrix: tileMatrix, score: score)
        previousStates.append(initialState)
        
        objectWillChange.send(self)
    }
    
    private enum TileGenerator {
        case single
        case double
    }
    
    @discardableResult
    private func generateBlocks(generator: TileGenerator) -> Bool {
        var blankLocations = [IndexPair]()
        
        for rowIndex in 0..<boardSize {
            for colIndex in 0..<boardSize {
                let index = (colIndex, rowIndex)
                
                if tileMatrix[index] == nil {
                    blankLocations.append(index)
                }
            }
        }

        defer {
            objectWillChange.send(self)
        }
                
        switch generator {
        case .single:
            return generateBlock(in: blankLocations)
        case .double:
            return generateBlockPair(in: blankLocations)
        }
    }
    
    // Modified tile generation:
    // Only generate tiles with values 1, 2, or 3.
    private func generateBlock(in blankLocations: [IndexPair]) -> Bool {
        guard blankLocations.count >= 1 else {
            return false
        }
        let placeLocIndex = Int.random(in: 0..<blankLocations.count)
        let newValue = Int.random(in: 1...2) // 1, 2, or 3
        tileMatrix.add(
            IdentifiedTile(
                id: mutableInstanceId,
                value: newValue
            ),
            to: blankLocations[placeLocIndex]
        )
        return true
    }
    
    private func generateBlockPair(in blankLocations: [IndexPair]) -> Bool {
        guard generateBlock(in: blankLocations) else {
            return false
        }
        guard let lastLoc = blankLocations.last else {
            return false
        }
        
        var blankLocations = blankLocations
        var placeLocIndex = Int.random(in: 0..<blankLocations.count)
        blankLocations[placeLocIndex] = lastLoc
        placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
        let newValue = Int.random(in: 1...2) // 1, 2, or 3
        tileMatrix.add(
            IdentifiedTile(
                id: mutableInstanceId,
                value: newValue
            ),
            to: blankLocations[placeLocIndex]
        )
        return true
    }
}
