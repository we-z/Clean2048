

import Foundation
import struct SwiftUI.Color

struct StandardTileColorTheme: TileColorTheme {
    
    var tileColors: [TilePair] = [
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.01), Color.white), // for tile 1
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.025), Color.white), // for tile 2
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.08), Color.white),  // for tile 3
            (Color(red:1.0, green:1.0, blue:1.0, opacity:0.15), Color.white),  // for tile 3
            (Color(red:1.0, green:1.0, blue:1.0, opacity:1.0), Color.black)  // for tile 3
        ]
}
