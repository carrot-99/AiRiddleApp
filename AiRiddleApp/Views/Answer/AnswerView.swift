//  AnswerView.swift

import SwiftUI

/// 答え合わせの内容（結果メッセージ・正解・AIの答え・あなたの答え）
struct AnswerView: View {
    let riddle: Riddle
    let userAnswer: String
    /// nil の場合はユーザーが正誤を判断中
    let outcome: RiddleResult.Outcome?

    var body: some View {
        VStack(spacing: 12) {
            if let outcome {
                ResultMessageView(outcome: outcome)
            }

            AnswerCardView(
                title: "せいかい",
                systemImage: "star.fill",
                tint: .orange,
                text: riddle.truth
            )

            AnswerCardView(
                title: "AIのこたえ",
                systemImage: "cpu",
                tint: .purple,
                text: riddle.ai,
                badge: riddle.isAICorrect
                    ? AnswerCardView.Badge(text: "AIも正解", color: .green)
                    : AnswerCardView.Badge(text: "AIはまちがい", color: .red)
            )

            AnswerCardView(
                title: "あなたのこたえ",
                systemImage: "person.fill",
                tint: .blue,
                text: AnswerText(answer: userAnswer.isEmpty ? "（未回答）" : userAnswer),
                badge: outcome.map(Self.userBadge(for:))
            )
        }
    }

    private static func userBadge(for outcome: RiddleResult.Outcome) -> AnswerCardView.Badge {
        switch outcome {
        case .correct: return AnswerCardView.Badge(text: "正解", color: .green)
        case .incorrect: return AnswerCardView.Badge(text: "不正解", color: .red)
        case .timeUp: return AnswerCardView.Badge(text: "時間切れ", color: .orange)
        case .skipped: return AnswerCardView.Badge(text: "スキップ", color: .gray)
        }
    }
}
