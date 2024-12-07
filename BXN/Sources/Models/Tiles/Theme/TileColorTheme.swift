
import SwiftUI

protocol TileColorTheme {
    typealias TilePair = (background: Color, font: Color)
    
    var tileColors: [TilePair] { get }
    
    func colorPair(for number: Int?, _ colorScheme: ColorScheme, defaultColor: Color) -> TilePair
}

extension TileColorTheme {
    func colorPair(for number: Int?, _ colorScheme: ColorScheme, defaultColor: Color) -> TilePair {
        guard let number = number else {
            return (defaultColor, Color.black)
        }
        
        // Map the tile values directly to indices:
        // 1 -> index 0
        // 2 -> index 1
        // 3 -> index 2
        let index: Int
        switch number {
        case 1:
            index = 0
        case 2:
            index = 1
        case 3:
            index = 2
        default:
            // If we ever get a number outside of 1, 2, or 3, fallback to default
            return (defaultColor, Color.black)
        }
        
        // Ensure index is within bounds
        guard index >= 0 && index < tileColors.count else {
            return (defaultColor, Color.black)
        }
        
        return tileColors[index]
    }
}

