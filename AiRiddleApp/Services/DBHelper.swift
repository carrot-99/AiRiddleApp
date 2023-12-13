//  DBHelper.swift

import SQLite

class DBHelper {
    private let db: Connection?
    private let riddles: Table = Table("Riddles")
    private let id: Expression<Int64> = Expression<Int64>("id")
    private let question: Expression<String> = Expression<String>("question")
    private let aiAnswer: Expression<String> = Expression<String>("aiAnswer")
    private let trueAnswer: Expression<String> = Expression<String>("trueAnswer")

    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
//            print("Database Connected: \(path)/db.sqlite3")
            createTable()
        } catch {
            print("Database Connection Error: \(error)")
            db = nil // エラー発生時に db を nil に設定
        }
    }

    private func createTable() {
        do {
            try! db!.run(riddles.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(question)
                table.column(aiAnswer)
                table.column(trueAnswer)
            })
//            print("Table Created")
        } catch {
            print("Create Table Error: \(error)")
        }
    }

    func addRiddle(riddle: Riddle) {
        guard let db = db else {
            print("Database not initialized")
            return
        }
        let insert = riddles.insert(question <- riddle.question, aiAnswer <- riddle.aiAnswer, trueAnswer <- riddle.trueAnswer)
        do {
            let rowId = try db.run(insert)
//            print("Inserted Riddle: \(rowId)")
        } catch {
            print("Insert Riddle Error: \(error)")
        }
    }

    func getAllRiddles() -> [Riddle] {
        guard let db = db else {
            print("Database not initialized")
            return []
        }
        var riddlesList = [Riddle]()
        do {
            let allRiddles = try db.prepare(riddles)
            for riddle in allRiddles {
                let fetchedRiddle = Riddle(
                    id: riddle[id],
                    question: riddle[question],
                    aiAnswer: riddle[aiAnswer],
                    trueAnswer: riddle[trueAnswer]
                )
                riddlesList.append(fetchedRiddle)
//                print("Fetched Riddle: \(fetchedRiddle.question)")
            }
        } catch {
            print("Fetch Riddles Error: \(error)")
        }
        return riddlesList
    }
    
    func isDatabaseEmpty() -> Bool {
        guard let db = db else {
            print("Database not initialized")
            return false
        }
        do {
            let count = try db.scalar(riddles.count)
            return count == 0
        } catch {
            print("Error checking if database is empty: \(error)")
            return true
        }
    }
}

extension DBHelper {
    func isRiddleExists(riddle: Riddle) -> Bool {
        guard let db = db else {
//            print("Database not initialized")
            return false
        }
        let query = riddles.filter(question == riddle.question)
        do {
            let count = try db.scalar(query.count)
            return count > 0
        } catch {
            print("Check Riddle Exists Error: \(error)")
            return false
        }
    }
}
