

import Foundation
import struct SwiftUI.Color

struct StandardTileColorTheme: TileColorTheme {
    
    var tileColors: [TilePair] = [
        (Color(red:1, green:1, blue:1, opacity:0.01), Color.white), // 2
        (Color(red:1, green:1, blue:1, opacity:0.03), Color.white), // 4
        (Color(red:1, green:1, blue:1, opacity:0.05), Color.white), // 8
        (Color(red:1, green:1, blue:1, opacity:0.07), Color.white), // 16
        (Color(red:1, green:1, blue:1, opacity:0.09), Color.white), // 32
        (Color(red:1, green:1, blue:1, opacity:0.11), Color.white), // 64
        (Color(red:1, green:1, blue:1, opacity:0.13), Color.white), // 128
        (Color(red:1, green:1, blue:1, opacity:0.15), Color.white), // 256
        (Color(red:1, green:1, blue:1, opacity:0.17), Color.white), // 512
        (Color(red:1, green:1, blue:1, opacity:0.19), Color.white), // 1024
        (Color(red:1, green:1, blue:1, opacity:1.0), Color.black), // 2048
        (Color(red:1, green:1, blue:1, opacity:1.0), Color.black), // 4096
    ]
}
