

import Foundation

enum PlistConfigurationKeyPath: String {
    
    // MARK: - About
    
    case about
    case copyright
    case linkDescription
    case linkUrl
    
    // MARK: - Settings
    
    case settings
    case gameBoardDescription
    case gameBoardSize
    case audio
    case audioDescription
    
    // MARK: - Game Board State
    
    case gameState
    case gameOverTitle
    case gameOverSubtitle
    case resetGameTitle
    case resetGameSubtitle
}
