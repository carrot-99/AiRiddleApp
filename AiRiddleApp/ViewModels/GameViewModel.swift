//  GameViewModel.swift

import Combine
import Foundation

/// 1ゲーム（コース1回分）の進行・タイマー・採点を管理する
final class GameViewModel: ObservableObject {
    enum Phase: Equatable {
        /// 回答入力中
        case answering
        /// 自動判定できなかったので、ユーザー自身が正誤を判断する
        case judging
        /// 結果表示中
        case revealed
    }

    static let timeLimit: TimeInterval = 30

    let course: Course
    let riddles: [Riddle]

    @Published private(set) var currentIndex = 0
    @Published private(set) var phase: Phase = .answering
    @Published private(set) var timeRemaining: TimeInterval = GameViewModel.timeLimit
    @Published private(set) var results: [RiddleResult] = []
    @Published var userAnswer = ""

    private var deadline: Date?
    private var timerCancellable: AnyCancellable?

    init(course: Course, riddles: [Riddle]) {
        self.course = course
        self.riddles = riddles
    }

    deinit {
        timerCancellable?.cancel()
    }

    // MARK: - State

    var currentRiddle: Riddle? {
        riddles.indices.contains(currentIndex) ? riddles[currentIndex] : nil
    }

    var isFinished: Bool { currentIndex >= riddles.count }
    var isLastQuestion: Bool { currentIndex == riddles.count - 1 }

    /// 現在の問題の結果（回答後のみ）
    var currentResult: RiddleResult? {
        guard let riddle = currentRiddle else { return nil }
        return results.last(where: { $0.riddle.id == riddle.id })
    }

    var correctCount: Int { results.filter(\.isCorrect).count }

    var canSubmit: Bool {
        phase == .answering && !userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Actions

    func startTimerIfNeeded() {
        guard phase == .answering, deadline == nil, !isFinished else { return }
        deadline = Date().addingTimeInterval(Self.timeLimit)
        timeRemaining = Self.timeLimit
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in self?.tick(now) }
    }

    func submit() {
        guard canSubmit, let riddle = currentRiddle else { return }
        stopTimer()
        if AnswerMatcher.isMatch(userAnswer, riddle.truth.answer) {
            record(.correct)
        } else {
            phase = .judging
        }
    }

    /// 「わからない」でスキップ
    func skip() {
        guard phase == .answering else { return }
        stopTimer()
        record(.skipped)
    }

    /// 自動判定できなかった回答を、ユーザー自身が判定する
    func judge(isCorrect: Bool) {
        guard phase == .judging else { return }
        record(isCorrect ? .correct : .incorrect)
    }

    func next() {
        guard phase == .revealed else { return }
        currentIndex += 1
        userAnswer = ""
        phase = .answering
        timeRemaining = Self.timeLimit
        startTimerIfNeeded()
    }

    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        deadline = nil
    }

    // MARK: - Private

    private func tick(_ now: Date) {
        guard let deadline else { return }
        timeRemaining = max(0, deadline.timeIntervalSince(now))
        if timeRemaining <= 0, phase == .answering {
            stopTimer()
            record(.timeUp)
        }
    }

    private func record(_ outcome: RiddleResult.Outcome) {
        guard let riddle = currentRiddle, currentResult == nil else { return }
        let answer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        results.append(RiddleResult(riddle: riddle, userAnswer: answer, outcome: outcome))
        phase = .revealed
        outcome == .correct ? Haptics.success() : Haptics.error()
    }
}
