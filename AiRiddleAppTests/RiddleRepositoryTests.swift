//  RiddleRepositoryTests.swift

import XCTest
@testable import AiRiddleApp

final class RiddleRepositoryTests: XCTestCase {
    private var fileURL: URL!
    private var repository: RiddleRepository!

    override func setUp() {
        fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("riddle-test-\(UUID().uuidString).sqlite3")
        repository = RiddleRepository(fileURL: fileURL)
    }

    override func tearDown() {
        repository = nil
        try? FileManager.default.removeItem(at: fileURL)
    }

    private func seed(_ question: String, ai: String = "AI。", truth: String = "こたえ。") -> RiddleSeed {
        RiddleSeed(question: question, aiAnswer: ai, trueAnswer: truth)
    }

    func testSyncInsertsNewRiddles() {
        repository.sync(with: [seed("Q1"), seed("Q2")])
        XCTAssertEqual(repository.fetchAll().map(\.question).sorted(), ["Q1", "Q2"])
    }

    func testSyncIsIdempotent() {
        let seeds = [seed("Q1"), seed("Q2")]
        repository.sync(with: seeds)
        repository.sync(with: seeds)
        XCTAssertEqual(repository.fetchAll().count, 2)
    }

    func testSyncUpdatesAnswersOfExistingQuestion() {
        repository.sync(with: [seed("Q1", truth: "古い。")])
        let originalID = repository.fetchAll().first?.id
        repository.sync(with: [seed("Q1", truth: "新しい。")])

        let riddle = try? XCTUnwrap(repository.fetchAll().first)
        XCTAssertEqual(riddle?.truth.answer, "新しい")
        XCTAssertEqual(riddle?.id, originalID, "既存の行は作り直さず更新する")
    }

    func testSyncDeletesRiddlesRemovedFromCSV() {
        repository.sync(with: [seed("Q1"), seed("Q2")])
        repository.sync(with: [seed("Q2")])
        XCTAssertEqual(repository.fetchAll().map(\.question), ["Q2"])
    }

    func testDuplicateQuestionsKeepFirstOccurrence() {
        repository.sync(with: [seed("Q1", truth: "先。"), seed("Q1", truth: "後。")])
        XCTAssertEqual(repository.fetchAll().map(\.truth.answer), ["先"])
    }

    func testEmptySeedsDoNotWipeDatabase() {
        repository.sync(with: [seed("Q1")])
        repository.sync(with: [])
        XCTAssertEqual(repository.fetchAll().count, 1, "CSVが読めなかったときにDBを空にしない")
    }
}
