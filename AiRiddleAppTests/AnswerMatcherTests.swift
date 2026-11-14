//  AnswerMatcherTests.swift

import XCTest
@testable import AiRiddleApp

final class AnswerMatcherTests: XCTestCase {
    func testIgnoresKanaWidthCaseAndSpaces() {
        XCTAssertTrue(AnswerMatcher.isMatch("ニンゲン", "にんげん"))
        XCTAssertTrue(AnswerMatcher.isMatch(" にんげん ", "にんげん"))
        XCTAssertTrue(AnswerMatcher.isMatch("ＡＢＣ", "abc"))
        XCTAssertTrue(AnswerMatcher.isMatch("ｺｰﾗ", "コーラ"))
    }

    func testBracketedAlternativesAreAccepted() {
        XCTAssertTrue(AnswerMatcher.isMatch("やきとりや", "やきとりや（焼き鳥屋）"))
        XCTAssertTrue(AnswerMatcher.isMatch("焼き鳥屋", "やきとりや（焼き鳥屋）"))
        XCTAssertTrue(AnswerMatcher.isMatch("9", "きゅう（9）"))
        XCTAssertTrue(AnswerMatcher.isMatch("きゅう", "きゅう（9）"))
    }

    func testLongVowelMarkIsSignificant() {
        XCTAssertTrue(AnswerMatcher.isMatch("こーら", "コーラ"))
        XCTAssertFalse(AnswerMatcher.isMatch("こら", "コーラ"))
    }

    func testRejectsEmptyAndPartialAnswers() {
        XCTAssertFalse(AnswerMatcher.isMatch("", "にんげん"))
        XCTAssertFalse(AnswerMatcher.isMatch("   ", "にんげん"))
        XCTAssertFalse(AnswerMatcher.isMatch("かわ", "つりかわ"))
    }
}

final class AnswerTextTests: XCTestCase {
    func testSplitsAnswerAndExplanationAtFirstPeriod() {
        let text = AnswerText("ひこうき。ひこう「き」。飛行機の話。")
        XCTAssertEqual(text.answer, "ひこうき")
        XCTAssertEqual(text.explanation, "ひこう「き」。飛行機の話。")
    }

    func testAnswerWithoutExplanation() {
        let text = AnswerText("トマト")
        XCTAssertEqual(text.answer, "トマト")
        XCTAssertEqual(text.explanation, "")
    }
}
