//  StatsStore.swift

import Foundation

/// これまでのプレイ記録
struct PlayStats: Codable, Equatable {
    var playCount = 0
    var answeredCount = 0
    var correctCount = 0
    var winsAgainstAI = 0
    /// コースID → ベストスコア（正解数）
    var bestScores: [String: Int] = [:]

    var accuracy: Double {
        answeredCount == 0 ? 0 : Double(correctCount) / Double(answeredCount)
    }

    func bestScore(for course: Course) -> Int? {
        bestScores[course.id]
    }
}

/// プレイ記録を UserDefaults に保存する
final class StatsStore {
    private let defaults: UserDefaults
    private let key = "playStats"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> PlayStats {
        guard let data = defaults.data(forKey: key),
              let stats = try? JSONDecoder().decode(PlayStats.self, from: data) else {
            return PlayStats()
        }
        return stats
    }

    func save(_ stats: PlayStats) {
        if let data = try? JSONEncoder().encode(stats) {
            defaults.set(data, forKey: key)
        }
    }
}
