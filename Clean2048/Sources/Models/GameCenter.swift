//
//  GameCenter.swift
//  2048 BLK
//
//  Created by Wheezy Capowdis on 11/24/24.
//

import GameKit


import Foundation

class GameCenter: ObservableObject {

    static let shared = GameCenter()

    // API

    // status of Game Center

    private(set) var isGameCenterEnabled: Bool = false


    func authenticateUser() {
        print("authenticateUser called")
        GKLocalPlayer.local.authenticateHandler = { _, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }

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

    // local player

    private var localPlayer = GKLocalPlayer.local

    // leaderboard ID from App Store Connect

    let leaderboardID = "grp.leaderboard"

    private var leaderboard: GKLeaderboard?
    let leaderboardIdentifier = "leaderboard"


}
