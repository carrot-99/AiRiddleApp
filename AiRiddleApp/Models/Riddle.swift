//  Riddle.swift

import Foundation

/// 「答え。解説…」形式の文字列を、答え部分と解説部分に分けたもの
struct AnswerText: Equatable {
    let answer: String
    let explanation: String

    init(answer: String, explanation: String = "") {
        self.answer = answer
        self.explanation = explanation
    }

    init(_ raw: String) {
        let parts = raw.split(separator: "。", maxSplits: 1, omittingEmptySubsequences: true)
        answer = parts.first.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? ""
        explanation = parts.count > 1 ? parts[1].trimmingCharacters(in: .whitespacesAndNewlines) : ""
    }
}

struct Riddle: Identifiable, Equatable {
    let id: Int64
    let question: String
    let aiAnswer: String
    let trueAnswer: String

    /// AIの答えと解説
    var ai: AnswerText { AnswerText(aiAnswer) }
    /// 正解と解説
    var truth: AnswerText { AnswerText(trueAnswer) }
    /// AIの答えが正解と一致しているか
    var isAICorrect: Bool { AnswerMatcher.isMatch(ai.answer, truth.answer) }
}
