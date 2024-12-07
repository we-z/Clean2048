

import Foundation
import struct SwiftUI.Color

struct StandardTileColorTheme: TileColorTheme {
    
    var tileColors: [TilePair] = [
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.01), Color.white), // for tile 1
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.04), Color.white), // for tile 2
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.18), Color.white)  // for tile 3
        ]
}
