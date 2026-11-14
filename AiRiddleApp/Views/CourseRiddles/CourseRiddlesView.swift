// CourseRiddlesView.swift

import SwiftUI

/// 1コース分のゲーム画面（出題 → 結果発表）
struct CourseRiddlesView: View {
    @ObservedObject var game: GameViewModel
    /// ゲーム終了時に結果を記録し、サマリーを返す
    let onFinish: () -> GameSummary
    let onRetry: () -> Void
    let onQuit: () -> Void

    @State private var summary: GameSummary?

    var body: some View {
        Group {
            if let summary {
                ScoreView(summary: summary, onRetry: onRetry, onHome: onQuit)
                    .transition(.opacity)
            } else if let riddle = game.currentRiddle {
                RiddleView(game: game, riddle: riddle, onQuit: onQuit)
                    .id(riddle.id)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: game.currentIndex)
        .onAppear(perform: finishIfNeeded)
        .onChange(of: game.currentIndex) { _ in finishIfNeeded() }
        .onDisappear { game.stopTimer() }
    }

    private func finishIfNeeded() {
        guard game.isFinished, summary == nil else { return }
        game.stopTimer()
        withAnimation { summary = onFinish() }
    }
}
