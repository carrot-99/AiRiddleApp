//  CSVReaderTests.swift

import XCTest
@testable import AiRiddleApp

final class CSVReaderTests: XCTestCase {
    func testParsesQuotedFieldsAndLineEndings() {
        let rows = CSVReader.parse("a,\"b,c\",\"d\"\"e\"\r\nx,y,z\n")
        XCTAssertEqual(rows, [["a", "b,c", "d\"e"], ["x", "y", "z"]])
    }

    func testQuoteInsideUnquotedFieldIsKeptAsIs() {
        let rows = CSVReader.parse("q,AI。 \"x\" です,t")
        XCTAssertEqual(rows, [["q", "AI。 \"x\" です", "t"]])
    }

    func testParsesLastLineWithoutNewline() {
        XCTAssertEqual(CSVReader.parse("a,b,c"), [["a", "b", "c"]])
    }
}

/// アプリに同梱している Riddle.csv の内容チェック。
/// 問題を追加・編集したらこのテストが通ることを確認する。
final class BundledRiddleCSVTests: XCTestCase {
    private var rawRows: [[String]] = []
    private var seeds: [RiddleSeed] = []

    override func setUpWithError() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "Riddle", withExtension: "csv"), "Riddle.csv がバンドルにありません")
        rawRows = CSVReader.parse(try String(contentsOf: url, encoding: .utf8))
            .filter { $0.contains { !$0.isEmpty } }
        seeds = CSVReader.loadRiddles()
    }

    func testEveryRowHasThreeColumns() {
        for (index, row) in rawRows.enumerated() {
            XCTAssertEqual(row.count, 3, "\(index + 1)行目の列数が \(row.count) です（カンマを含む欄は \"...\" で囲んでください）")
        }
        XCTAssertEqual(seeds.count, rawRows.count)
    }

    func testNoEmptyFields() {
        for seed in seeds {
            XCTAssertFalse(AnswerText(seed.aiAnswer).answer.isEmpty, "AIの答えが空: \(seed.question)")
            XCTAssertFalse(AnswerText(seed.trueAnswer).answer.isEmpty, "正解が空: \(seed.question)")
        }
    }

    func testNoDuplicateQuestions() {
        var seen = Set<String>()
        for seed in seeds {
            XCTAssertTrue(seen.insert(seed.question).inserted, "問題文が重複しています: \(seed.question)")
        }
    }

    func testEveryTrueAnswerCanBeTypedCorrectly() {
        for seed in seeds {
            let answer = AnswerText(seed.trueAnswer).answer
            XCTAssertTrue(AnswerMatcher.isMatch(answer, answer), "正解を入力しても正解にならない: \(answer)")
        }
    }
}
