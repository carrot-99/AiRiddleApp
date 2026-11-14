//  Course.swift

import SwiftUI

enum Course: String, CaseIterable, Identifiable {
    case quick
    case standard
    case challenge

    var id: String { rawValue }

    var questionCount: Int {
        switch self {
        case .quick: return 5
        case .standard: return 10
        case .challenge: return 20
        }
    }

    var title: String {
        switch self {
        case .quick: return "おためしコース"
        case .standard: return "10問コース"
        case .challenge: return "20問コース"
        }
    }

    var subtitle: String {
        switch self {
        case .quick: return "サクッと5問"
        case .standard: return "定番の10問"
        case .challenge: return "じっくり20問"
        }
    }

    var iconName: String {
        switch self {
        case .quick: return "hare.fill"
        case .standard: return "star.fill"
        case .challenge: return "flame.fill"
        }
    }

    var color: Color {
        switch self {
        case .quick: return .teal
        case .standard: return .green
        case .challenge: return .pink
        }
    }
}
