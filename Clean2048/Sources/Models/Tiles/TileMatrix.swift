

import SwiftUI

struct TileMatrix<T>: CustomStringConvertible, CustomDebugStringConvertible where T: Tile, T.Value: Equatable {

    // MARK: - Conformance to CustomStringConvertible and CustomDebugStringConvertible protocols
    
    var description: String {
        commonDescription
    }
    var debugDescription: String {
        commonDescription
    }
    
    private var commonDescription: String {
        matrix.map { row -> String in
            row.map {
                if $0 == nil {
                    return " "
                } else {
                    guard let value = $0?.value else {
                        return "?"
                    }
                    return String(describing: value)
                }
            }.joined(separator: "\t")
        }.joined(separator: "\n")
    }
    
    // MARK: - Properties
    
    
    private(set) var matrix: [[T?]]
    private let size: Int
    
    // MARK: - Initializers
    
    init(size: Int = 4) {
        self.size = size
        
        matrix = [[T?]]()
        for _ in 0..<size {
            var row = [T?]()
            for _ in 0..<size {
                row += [nil]
            }
            matrix += [row]
        }
    }
    
    // MARK: Subscripts
    
    subscript(index: IndexPair) -> T? {
        guard isValid(index: index) else { return nil }
        return matrix[index.1][index.0]
    }
    
    // MARK: - Methods
    
    mutating func add(_ tile: T?, to: IndexPair) {
        matrix[to.1][to.0] = tile
    }
    
    mutating func move(from: IndexPair, to: IndexPair, with value: T.Value) {
        move(from: from, to: to, sourceReplacement: { value })
    }
    
    mutating func move(from: IndexPair, to: IndexPair) {
       move(from: from, to: to, sourceReplacement: nil)
    }
    
    func flatten() -> [IndexedTile<T>] {
        matrix.enumerated().flatMap { (y: Int, element: [T?]) in
            element.enumerated().compactMap { (x: Int, tile: T?) in
                guard let tile = tile else {
                    return nil
                }
                return IndexedTile(index: (x, y), tile: tile)
            }
        }
    }
    
    func equals(to matrix: TileMatrix<T>) -> Bool {
        self.matrix == matrix.matrix
    }
    
    func isMovePossible() -> Bool {
            let size = matrix.count
            for x in 0..<size {
                for y in 0..<size {
                    if matrix[x][y] == nil {
                        return true  // Empty space found, so a move is possible
                    }
                    let currentTile = matrix[x][y]!
                    // Check right neighbor
                    if x + 1 < size, let rightTile = matrix[x + 1][y], rightTile.value == currentTile.value {
                        return true  // Merge possible to the right
                    }
                    // Check down neighbor
                    if y + 1 < size, let downTile = matrix[x][y + 1], downTile.value == currentTile.value {
                        return true  // Merge possible downward
                    }
                }
            }
            // No moves are possible
            return false
        }

    // MARK: - Private Helpers
    
    private mutating func move(from: IndexPair, to: IndexPair, sourceReplacement: (() -> T.Value)?) {
        guard
            isValid(index: from) && isValid(index: to),
            var source = self[from]
            else {
                return
        }
        if let sourceReplacement = sourceReplacement {
            let value = sourceReplacement()
            source.value = value
        }
        
        matrix[to.1][to.0] = source
        matrix[from.1][from.0] = nil
    }
    
    private func isValid(index: IndexPair) -> Bool {
        guard
            index.0 >= 0 && index.0 < size,
            index.1 >= 0 && index.1 < size
            else { return false }
        return true
    }
}
