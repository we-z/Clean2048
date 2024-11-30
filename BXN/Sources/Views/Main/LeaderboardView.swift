//
//  LeaderboardView.swift
//  BXN
//
//  Created by Wheezy Capowdis on 11/26/24.
//

import Foundation
import GameKit
import SwiftUI

struct LeaderboardView: UIViewControllerRepresentable {
    let leaderboardID: String
    let playerScope: GKLeaderboard.PlayerScope
    let timeScope: GKLeaderboard.TimeScope
    
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let viewController = GKGameCenterViewController(
            leaderboardID: leaderboardID,
            playerScope: playerScope,
            timeScope: timeScope
        )
        viewController.gameCenterDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // No need to update anything for this view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: false, completion: nil)
        }
    }
}
