//  ResultMessageView.swift

import SwiftUI

struct ResultMessageView: View {
    let outcome: RiddleResult.Outcome

    @State private var isVisible = false

    var body: some View {
        Label(outcome.message, systemImage: outcome.iconName)
            .font(.system(.largeTitle, design: .rounded).weight(.heavy))
            .foregroundColor(outcome.color)
            .padding(.vertical, 4)
            .scaleEffect(isVisible ? 1 : 0.5)
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { isVisible = true }
            }
    }
}

extension RiddleResult.Outcome {
    var message: String {
        switch self {
        case .correct: return "正解！"
        case .incorrect: return "ざんねん…"
        case .timeUp: return "時間切れ！"
        case .skipped: return "スキップ"
        }
    }

    var iconName: String {
        switch self {
        case .correct: return "checkmark.circle.fill"
        case .incorrect: return "xmark.circle.fill"
        case .timeUp: return "timer"
        case .skipped: return "forward.fill"
        }
    }

    var color: Color {
        switch self {
        case .correct: return .green
        case .incorrect: return .red
        case .timeUp: return .orange
        case .skipped: return .gray
        }
    }
}
