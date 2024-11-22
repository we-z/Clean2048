

import Foundation
import struct SwiftUI.Color

struct StandardTileColorTheme: TileColorTheme {
    
    var tileColors: [TilePair] = [
        (Color(red:1, green:1, blue:1, opacity:0.1), Color.white), // 2
        (Color(red:1, green:1, blue:1, opacity:0.2), Color.white), // 4
        (Color(red:1, green:1, blue:1, opacity:0.3), Color.white), // 8
        (Color(red:1, green:1, blue:1, opacity:0.4), Color.white), // 16
        (Color(red:1, green:1, blue:1, opacity:0.5), Color.white), // 32
        (Color(red:1, green:1, blue:1, opacity:0.6), Color.white), // 64
        (Color(red:1, green:1, blue:1, opacity:0.7), Color.white), // 128
        (Color(red:1, green:1, blue:1, opacity:0.8), Color.white), // 256
        (Color(red:1, green:1, blue:1, opacity:0.9), Color.white), // 512
        (Color(red:1, green:1, blue:1, opacity:0.0), Color.black), // 1024
        (Color(red:1, green:1, blue:1, opacity:0.0), Color.black), // 2048
        (Color(red:1, green:1, blue:1, opacity:0.0), Color.black), // 4096
    ]
}
