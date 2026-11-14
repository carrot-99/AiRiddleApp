//  RiddleRepository.swift

import Foundation
import SQLite

/// なぞなぞを SQLite に保存・取得する
final class RiddleRepository {
    private let db: Connection?

    private let riddles = Schema.table
    private let id = Schema.id
    private let question = Schema.question
    private let aiAnswer = Schema.aiAnswer
    private let trueAnswer = Schema.trueAnswer

    private enum Schema {
        static let table = Table("Riddles")
        static let id = SQLite.Expression<Int64>("id")
        static let question = SQLite.Expression<String>("question")
        static let aiAnswer = SQLite.Expression<String>("aiAnswer")
        static let trueAnswer = SQLite.Expression<String>("trueAnswer")
    }

    /// - Parameter fileURL: DBファイルの場所。省略時は Documents/db.sqlite3（テストでは一時ファイルを渡す）
    init(fileURL: URL? = nil) {
        do {
            let url = try fileURL ?? Self.defaultFileURL()
            let connection = try Connection(url.path)
            try connection.run(Schema.table.create(ifNotExists: true) { table in
                table.column(Schema.id, primaryKey: .autoincrement)
                table.column(Schema.question)
                table.column(Schema.aiAnswer)
                table.column(Schema.trueAnswer)
            })
            db = connection
        } catch {
            print("Database setup error: \(error)")
            db = nil
        }
    }

    private static func defaultFileURL() throws -> URL {
        try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite3")
    }

    /// CSVの内容をDBへ反映する
    /// （新しい問題は追加、既存の問題は答えを最新化、CSVからなくなった問題は削除）
    func sync(with seeds: [RiddleSeed]) {
        guard let db, !seeds.isEmpty else { return }
        // 同じ問題文が複数ある場合は先に出てきたものを採用する
        var seen = Set<String>()
        let uniqueSeeds = seeds.filter { seen.insert($0.question).inserted }
        do {
            try db.transaction {
                try db.run(riddles.filter(!Array(seen).contains(question)).delete())
                for seed in uniqueSeeds {
                    let existing = riddles.filter(question == seed.question)
                    if try db.scalar(existing.count) > 0 {
                        try db.run(existing.update(aiAnswer <- seed.aiAnswer, trueAnswer <- seed.trueAnswer))
                    } else {
                        try db.run(riddles.insert(
                            question <- seed.question,
                            aiAnswer <- seed.aiAnswer,
                            trueAnswer <- seed.trueAnswer
                        ))
                    }
                }
            }
        } catch {
            print("Database sync error: \(error)")
        }
    }

    func fetchAll() -> [Riddle] {
        guard let db else { return [] }
        do {
            return try db.prepare(riddles).map { row in
                Riddle(id: row[id], question: row[question], aiAnswer: row[aiAnswer], trueAnswer: row[trueAnswer])
            }
        } catch {
            print("Database fetch error: \(error)")
            return []
        }
    }
}
