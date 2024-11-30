//
//  GameCenter.swift
//  2048 BLK
//
//  Created by Wheezy Capowdis on 11/24/24.
//

import GameKit
import SwiftUI

import Foundation

class GameCenter: ObservableObject {

    static let shared = GameCenter()
    
    // leaderboard ID from App Store Connect

    let leaderboardID = "bxnleaderboard"


    // update local player score

    func updateScore(score: Int) {
        // push score to Game Center
        Task {
            GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [self.leaderboardID]) { error in
                if let error = error {
                    print("Error submitting score: \(error)")
                } else {
                    print("Score submitted to daily successfully")
                }
            }
        }
    }

}
