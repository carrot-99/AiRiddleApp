//  RiddleViewModel.swift

import Foundation

class RiddleViewModel: ObservableObject {
    @Published var riddles: [Riddle] = []
    @Published var correctAnswerCount = 0
    @Published var riddleResults: [RiddleResult] = []
    private var dbHelper: DBHelper = DBHelper()

    init() {
        if dbHelper.isDatabaseEmpty() {
            let csvReader = CSVReader()
            let riddles = csvReader.readCSV(fileName: "Riddle")
            riddles.forEach { riddle in
                dbHelper.addRiddle(riddle: riddle)
            }
        }
        fetchRiddles()
    }
    
    func initializeDatabaseIfNeeded() {
        if dbHelper.isDatabaseEmpty() {
            let csvReader = CSVReader()
            let riddles = csvReader.readCSV(fileName: "Riddle")
            riddles.forEach { riddle in
                dbHelper.addRiddle(riddle: riddle)
                print("Adding riddle: \(riddle.question)")
            }
        }
        fetchRiddles()
    }

    func fetchRiddles() {
        self.riddles = dbHelper.getAllRiddles()
        print("riddles count:\(riddles.count)")
    }

    func addRiddle(riddle: Riddle) {
        dbHelper.addRiddle(riddle: riddle)
        fetchRiddles()
    }
}

extension RiddleViewModel {
    func addNewRiddlesFromCSV() {
        let csvReader = CSVReader()
        let newRiddles = csvReader.readCSV(fileName: "Riddle")

        newRiddles.forEach { riddle in
            if !dbHelper.isRiddleExists(riddle: riddle) {
                dbHelper.addRiddle(riddle: riddle)
            }
        }
        fetchRiddles()
    }
    
    func getRandomRiddles(count: Int) -> [Riddle] {
        Array(riddles.shuffled().prefix(count))
    }
    
    func checkUserAnswer(_ userAnswer: String, for riddle: Riddle) -> Bool {
        let normalizedUserAnswer = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        // trueAnswerを「。」で区切って、答えの部分のみを取得
        let answerComponents = riddle.trueAnswer.split(separator: "。", maxSplits: 1, omittingEmptySubsequences: true)
        let trueAnswerPart = answerComponents.first.map(String.init) ?? ""
        let normalizedTrueAnswerPart = trueAnswerPart.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        print("trueAnswer:\(trueAnswerPart)")
        let isCorrect = normalizedUserAnswer == normalizedTrueAnswerPart
        if isCorrect {
            correctAnswerCount += 1
            riddleResults.append(RiddleResult(riddle: riddle, isCorrect: true))
        }
        return isCorrect
    }
    
    func resetGame() {
        correctAnswerCount = 0
        riddleResults.removeAll()
    }
    
    func updateUserAnswer(for riddle: Riddle, isCorrect: Bool) {
        // 結果を探して更新する
        if let index = riddleResults.firstIndex(where: { $0.riddle.id == riddle.id }) {
            riddleResults[index].isCorrect = isCorrect
        } else {
            // まだ結果がない場合は追加する
            riddleResults.append(RiddleResult(riddle: riddle, isCorrect: isCorrect))
        }
        if isCorrect {
            // 正解数を更新する
            correctAnswerCount += 1
        }
    }
}
