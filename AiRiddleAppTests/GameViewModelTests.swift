//  GameViewModelTests.swift

import XCTest
@testable import AiRiddleApp

final class GameViewModelTests: XCTestCase {
    private func riddle(_ id: Int64, truth: String, ai: String = "ちがう。") -> Riddle {
        Riddle(id: id, question: "Q\(id)", aiAnswer: ai, trueAnswer: truth)
    }

    private func makeGame(count: Int = 3) -> GameViewModel {
        let riddles = (1...count).map { riddle(Int64($0), truth: "こたえ\($0)。解説") }
        return GameViewModel(course: .quick, riddles: riddles)
    }

    func testMatchingAnswerIsJudgedCorrectAutomatically() {
        let game = makeGame()
        game.userAnswer = "コタエ1"
        game.submit()

        XCTAssertEqual(game.phase, .revealed)
        XCTAssertEqual(game.currentResult?.outcome, .correct)
        XCTAssertEqual(game.correctCount, 1)
    }

    func testNonMatchingAnswerAsksUserToJudge() {
        let game = makeGame()
        game.userAnswer = "ぜんぜんちがう"
        game.submit()

        XCTAssertEqual(game.phase, .judging)
        XCTAssertTrue(game.results.isEmpty, "自己判定が終わるまで結果は記録しない")

        game.judge(isCorrect: true)
        game.judge(isCorrect: false) // 2回目は無視される
        XCTAssertEqual(game.results.map(\.outcome), [.correct])
    }

    func testEmptyAnswerCannotBeSubmitted() {
        let game = makeGame()
        game.userAnswer = "   "
        XCTAssertFalse(game.canSubmit)
        game.submit()
        XCTAssertEqual(game.phase, .answering)
    }

    func testSkipRecordsSkippedResult() {
        let game = makeGame()
        game.skip()
        XCTAssertEqual(game.currentResult?.outcome, .skipped)
        XCTAssertEqual(game.correctCount, 0)
    }

    func testNextAdvancesAndResetsInput() {
        let game = makeGame()
        game.userAnswer = "こたえ1"
        game.submit()
        game.next()

        XCTAssertEqual(game.currentIndex, 1)
        XCTAssertEqual(game.phase, .answering)
        XCTAssertEqual(game.userAnswer, "")
        XCTAssertNil(game.currentResult)
        game.stopTimer()
    }

    func testNextIsIgnoredBeforeAnswering() {
        let game = makeGame()
        game.next()
        XCTAssertEqual(game.currentIndex, 0)
    }

    func testPlayingThroughFinishesGame() {
        let game = makeGame(count: 2)
        game.skip(); game.next()
        XCTAssertTrue(game.isLastQuestion)
        game.skip(); game.next()

        XCTAssertTrue(game.isFinished)
        XCTAssertNil(game.currentRiddle)
        XCTAssertEqual(game.results.count, 2)
    }

    func testTimerStartsAtLimitAndCountsDown() {
        let game = makeGame()
        game.startTimerIfNeeded()
        XCTAssertEqual(game.timeRemaining, GameViewModel.timeLimit)

        RunLoop.main.run(until: Date().addingTimeInterval(0.35))
        XCTAssertLessThan(game.timeRemaining, GameViewModel.timeLimit)
        game.stopTimer()
    }
}
