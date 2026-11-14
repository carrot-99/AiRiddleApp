//  RiddleViewModel.swift

import Foundation

/// なぞなぞの一覧とプレイ記録を管理する（アプリ全体で1つ）
final class RiddleViewModel: ObservableObject {
    @Published private(set) var riddles: [Riddle] = []
    @Published private(set) var stats: PlayStats

    private let repository: RiddleRepository
    private let statsStore: StatsStore

    init(repository: RiddleRepository = RiddleRepository(), statsStore: StatsStore = StatsStore()) {
        self.repository = repository
        self.statsStore = statsStore
        self.stats = statsStore.load()
        loadRiddles()
    }

    /// CSVの問題をDBへ反映して読み込み直す
    func loadRiddles() {
        repository.sync(with: CSVReader.loadRiddles())
        riddles = repository.fetchAll()
    }

    func makeGame(for course: Course) -> GameViewModel {
        let selected = Array(riddles.shuffled().prefix(course.questionCount))
        return GameViewModel(course: course, riddles: selected)
    }

    /// ゲーム結果を記録し、結果サマリーを返す
    func record(_ game: GameViewModel) -> GameSummary {
        let results = game.results
        let correct = results.filter(\.isCorrect).count
        let aiCorrect = results.filter(\.riddle.isAICorrect).count

        let previousBest = stats.bestScore(for: game.course)
        // 過去の記録を上回ったときだけ「ベスト更新」とする
        let isNewBest = previousBest.map { correct > $0 } ?? false

        stats.playCount += 1
        stats.answeredCount += results.count
        stats.correctCount += correct
        if correct > aiCorrect { stats.winsAgainstAI += 1 }
        stats.bestScores[game.course.id] = max(previousBest ?? 0, correct)
        statsStore.save(stats)

        return GameSummary(course: game.course, results: results, isNewBest: isNewBest)
    }
}
