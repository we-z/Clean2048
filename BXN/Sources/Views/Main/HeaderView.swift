//
//  HeaderView.swift
//  BXN
//
//  Created by Wheezy Capowdis on 11/26/24.
//

import SwiftUI

let impactLight = UIImpactFeedbackGenerator(style: .light)

struct HeaderView: View {
    @State var showLeaderboard = false
    @State var hasGameEnded = false
    @ObservedObject var logic = GameLogic.shared
    @ObservedObject var gameCenter: GameCenter = GameCenter.shared
    @StateObject private var storeKitManager = StoreKitManager()
    @AppStorage("bestScoreBXN5") var bestScore: Int = 0
    @State private var showAlert = false
    @State private var score: Int = 0 {
        didSet {
            if score > bestScore {
                bestScore = score
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                Button {
                    impactLight.impactOccurred()
                    Task {
                            do {
                                if let transaction = try await storeKitManager.purchase() {
                                    // Handle successful purchase
                                    print("Purchase successful: \(transaction)")
                                }
                            } catch {
                                // Handle errors
                                print("Purchase failed: \(error)")
                            }
                        }
                } label: {
                    Text("Tip $5")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(9)
                        .padding(.horizontal, 6)
                        .background{
                            Color.white
                                .opacity(0.1)
                        }
                        .cornerRadius(6)
//                        .padding(.horizontal)
                }
                Spacer()
                Button {
                    impactLight.impactOccurred()
                    showLeaderboard = true
                    gameCenter.updateScore(score: bestScore)
                } label: {
                    Text("Leaderboard")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(9)
                        .padding(.horizontal, 6)
                        .background{
                            Color.white
                                .opacity(0.1)
                        }
                        .cornerRadius(6)
//                        .padding(.horizontal)
                }
                Spacer()
            }
            Spacer()
            if hasGameEnded{
                VStack {
                    Text("Game Over")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(.gray)
                    
                    Text("\(score)")
                        .font(Font.system(.largeTitle))
                        .foregroundColor(.white)
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        .id("Score \(self.score)")
                }
            } else {
                HStack {
                    
                    Spacer()
                    VStack {
                        Text("Score")
                            .font(Font.system(.largeTitle))
                            .foregroundColor(.gray)
                        
                        Text("\(score)")
                            .font(Font.system(.largeTitle))
                            .foregroundColor(.white)
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                            .id("Score \(self.score)")
                    }
                    Spacer()
                    VStack {
                        Text("Best")
                            .font(Font.system(.largeTitle))
                            .foregroundColor(.gray)
                        
                        Text("\(bestScore)")
                            .font(Font.system(.largeTitle))
                            .foregroundColor(.white)
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                            .id("Score \(self.bestScore)")
                    }
                    Spacer()
                    
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    impactLight.impactOccurred()
                    showAlert = true
                } label: {
                    Text("Reset")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background{
                            Color.white
                                .opacity(0.1)
                        }
                        .cornerRadius(6)
                }
                Spacer()
                Button {
                    impactLight.impactOccurred()
                    if !hasGameEnded {
                        logic.undo()
                    }
                } label: {
                    Text("Undo")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background{
                            Color.white
                                .opacity(0.1)
                        }
                        .cornerRadius(6)
                }
                Spacer()
            }
            Spacer()
        }
        .onAppear{
            self.hasGameEnded = logic.noPossibleMove
        }
        .onChange(of: logic.noPossibleMove) { _ in
            self.hasGameEnded = logic.noPossibleMove
            if self.hasGameEnded {
                gameCenter.updateScore(score: bestScore)
            }
        }
        .onReceive(logic.$score) { (publishedScore) in
            score = publishedScore
        }
        .alert("Reset Game?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetGame()
            }
        }
        .fullScreenCover(isPresented: $showLeaderboard) {
            LeaderboardView(
                leaderboardID: "bxnleaderboard",
                playerScope: .global,
                timeScope: .allTime
            )
        }
    }
    
    private func resetGame() {
        hasGameEnded = false
        logic.reset()
    }
    
}

#Preview {
    CompositeView()
}
