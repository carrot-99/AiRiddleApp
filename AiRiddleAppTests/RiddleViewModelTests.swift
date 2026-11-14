//  RiddleViewModelTests.swift

import XCTest
@testable import AiRiddleApp

final class RiddleViewModelTests: XCTestCase {
    private var dbURL: URL!
    private var defaults: UserDefaults!
    private let suiteName = "RiddleViewModelTests"

    override func setUp() {
        dbURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("riddle-vm-\(UUID().uuidString).sqlite3")
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        try? FileManager.default.removeItem(at: dbURL)
    }

    private func makeViewModel() -> RiddleViewModel {
        RiddleViewModel(repository: RiddleRepository(fileURL: dbURL), statsStore: StatsStore(defaults: defaults))
    }

    /// 先頭から `correct` 問を正解、残りをスキップしてゲームを終える
    private func play(_ viewModel: RiddleViewModel, course: Course, correct: Int) -> GameSummary {
        let game = viewModel.makeGame(for: course)
        for index in game.riddles.indices {
            if index < correct {
                game.userAnswer = game.currentRiddle!.truth.answer
                game.submit()
            } else {
                game.skip()
            }
            game.next()
        }
        return viewModel.record(game)
    }

    func testLoadsBundledRiddles() {
        XCTAssertGreaterThanOrEqual(makeViewModel().riddles.count, Course.challenge.questionCount)
    }

    func testMakeGamePicksDistinctRiddlesForCourse() {
        let game = makeViewModel().makeGame(for: .standard)
        XCTAssertEqual(game.riddles.count, Course.standard.questionCount)
        XCTAssertEqual(Set(game.riddles.map(\.id)).count, game.riddles.count)
    }

    func testRecordUpdatesStatsAndBestScore() {
        let viewModel = makeViewModel()

        let first = play(viewModel, course: .quick, correct: 2)
        XCTAssertFalse(first.isNewBest, "初回は比較対象がないので「ベスト更新」にしない")
        XCTAssertEqual(viewModel.stats.bestScore(for: .quick), 2)

        let second = play(viewModel, course: .quick, correct: 3)
        XCTAssertTrue(second.isNewBest)

        let third = play(viewModel, course: .quick, correct: 1)
        XCTAssertFalse(third.isNewBest)

        XCTAssertEqual(viewModel.stats.playCount, 3)
        XCTAssertEqual(viewModel.stats.correctCount, 6)
        XCTAssertEqual(viewModel.stats.answeredCount, 15)
        XCTAssertEqual(viewModel.stats.bestScore(for: .quick), 3)
        XCTAssertNil(viewModel.stats.bestScore(for: .standard))
    }

    func testStatsArePersisted() {
        _ = play(makeViewModel(), course: .quick, correct: 4)
        let reloaded = makeViewModel()
        XCTAssertEqual(reloaded.stats.playCount, 1)
        XCTAssertEqual(reloaded.stats.bestScore(for: .quick), 4)
    }
}
