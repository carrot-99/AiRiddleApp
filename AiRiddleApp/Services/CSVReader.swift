//  CSVReader.swift

import Foundation

/// CSVから読み込んだ、DB登録前のなぞなぞ
struct RiddleSeed: Equatable {
    let question: String
    let aiAnswer: String
    let trueAnswer: String
}

enum CSVReader {
    /// バンドル内のCSV（問題,AIの答え,正解）を読み込む
    static func loadRiddles(resource: String = "Riddle", bundle: Bundle = .main) -> [RiddleSeed] {
        guard let url = bundle.url(forResource: resource, withExtension: "csv"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            print("CSV file not found: \(resource).csv")
            return []
        }
        return parse(text).compactMap { columns in
            guard columns.count == 3 else {
                if columns.contains(where: { !$0.isEmpty }) {
                    print("Skipped invalid CSV row: \(columns)")
                }
                return nil
            }
            let trimmed = columns.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard !trimmed[0].isEmpty else { return nil }
            return RiddleSeed(question: trimmed[0], aiAnswer: trimmed[1], trueAnswer: trimmed[2])
        }
    }

    /// RFC 4180 準拠の簡易CSVパーサ（ダブルクォートで囲まれたカンマ・改行に対応）
    static func parse(_ text: String) -> [[String]] {
        var rows: [[String]] = []
        var row: [String] = []
        var field = ""
        var inQuotes = false
        var iterator = text.makeIterator()
        var pending: Character? = nil

        func nextChar() -> Character? {
            if let c = pending { pending = nil; return c }
            return iterator.next()
        }

        while let c = nextChar() {
            if inQuotes {
                if c == "\"" {
                    if let following = nextChar() {
                        if following == "\"" {
                            field.append("\"")
                        } else {
                            inQuotes = false
                            pending = following
                        }
                    } else {
                        inQuotes = false
                    }
                } else {
                    field.append(c)
                }
                continue
            }

            switch c {
            case "\"" where field.isEmpty:
                inQuotes = true
            case ",":
                row.append(field)
                field = ""
            case "\n", "\r\n", "\r":
                row.append(field)
                rows.append(row)
                row = []
                field = ""
            default:
                field.append(c)
            }
        }

        if !field.isEmpty || !row.isEmpty {
            row.append(field)
            rows.append(row)
        }
        return rows
    }
}
