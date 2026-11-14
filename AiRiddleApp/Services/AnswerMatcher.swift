//  AnswerMatcher.swift

import Foundation

/// ユーザーの回答と正解を、表記ゆれを吸収して比較する
///
/// - ひらがな/カタカナ、全角/半角、大文字/小文字、空白・記号の違いを無視
/// - 「やきとりや（焼き鳥屋）」のような括弧書きは、括弧の外・中どちらでも正解扱い
enum AnswerMatcher {
    static func isMatch(_ input: String, _ expected: String) -> Bool {
        let inputForms = Set([normalize(input), normalize(removingBrackets(input))]).subtracting([""])
        return !inputForms.isDisjoint(with: acceptableForms(of: expected))
    }

    static func acceptableForms(of expected: String) -> Set<String> {
        var forms: Set<String> = [normalize(expected), normalize(removingBrackets(expected))]
        forms.formUnion(bracketContents(of: expected).map(normalize))
        forms.remove("")
        return forms
    }

    static func normalize(_ text: String) -> String {
        let folded = text
            .precomposedStringWithCompatibilityMapping // 全角英数→半角、半角カナ→全角
            .lowercased()
        let hiragana = folded.applyingTransform(.hiraganaToKatakana, reverse: true) ?? folded
        return String(hiragana.unicodeScalars.filter { !ignoredScalars.contains($0) })
    }

    // MARK: - Private

    private static let bracketPattern = "[（(][^）)]*[）)]"

    private static let ignoredScalars: CharacterSet = {
        var set = CharacterSet.whitespacesAndNewlines
        set.formUnion(.punctuationCharacters)
        set.formUnion(.symbols)
        set.insert(charactersIn: "〜~")
        set.remove(charactersIn: "ー") // 長音は意味を持つので残す
        return set
    }()

    private static func removingBrackets(_ text: String) -> String {
        text.replacingOccurrences(of: bracketPattern, with: "", options: .regularExpression)
    }

    private static func bracketContents(of text: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: bracketPattern) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let r = Range(match.range, in: text) else { return nil }
            return String(text[r].dropFirst().dropLast())
        }
    }
}
