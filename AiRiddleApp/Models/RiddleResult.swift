//  RiddleResult.swift

import Foundation

struct RiddleResult: Identifiable, Equatable {
    enum Outcome: Equatable {
        case correct
        case incorrect
        case timeUp
        case skipped
    }

    let riddle: Riddle
    let userAnswer: String
    let outcome: Outcome

    var id: Int64 { riddle.id }
    var isCorrect: Bool { outcome == .correct }
}

/// 1ゲーム分の結果
struct GameSummary {
    enum Verdict {
        case win, draw, lose
    }

    let course: Course
    let results: [RiddleResult]
    let isNewBest: Bool

    var total: Int { results.count }
    var correctCount: Int { results.filter(\.isCorrect).count }
    var aiCorrectCount: Int { results.filter(\.riddle.isAICorrect).count }

    var verdict: Verdict {
        if correctCount > aiCorrectCount { return .win }
        if correctCount == aiCorrectCount { return .draw }
        return .lose
    }
}
