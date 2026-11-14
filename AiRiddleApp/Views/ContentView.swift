//  ContentView.swift

import SwiftUI

struct ContentView: View {
    private enum Screen: Equatable {
        case title
        case courseSelection
        case playing
    }

    @StateObject private var viewModel = RiddleViewModel()
    @AppStorage("hasAgreedToTerms") private var hasAgreedToTerms = false
    @State private var screen: Screen = .title
    @State private var game: GameViewModel?

    var body: some View {
        Group {
            if hasAgreedToTerms {
                mainContent
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        AdMobBannerView.ifConfigured()
                    }
            } else {
                TermsAndPrivacyAgreementView {
                    withAnimation { hasAgreedToTerms = true }
                }
            }
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        ZStack {
            switch screen {
            case .title:
                TitleView(stats: viewModel.stats) {
                    show(.courseSelection)
                }
                .transition(.opacity)

            case .courseSelection:
                CourseSelectionView(
                    availableCount: viewModel.riddles.count,
                    stats: viewModel.stats,
                    onSelect: start(_:),
                    onBack: { show(.title) }
                )
                .transition(.move(edge: .trailing))

            case .playing:
                if let game {
                    CourseRiddlesView(
                        game: game,
                        onFinish: { viewModel.record(game) },
                        onRetry: { start(game.course) },
                        onQuit: endGame
                    )
                    .id(ObjectIdentifier(game))
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screen)
    }

    private func show(_ next: Screen) {
        withAnimation(.easeInOut(duration: 0.3)) { screen = next }
    }

    private func start(_ course: Course) {
        game?.stopTimer()
        game = viewModel.makeGame(for: course)
        show(.playing)
    }

    private func endGame() {
        game?.stopTimer()
        show(.title)
        game = nil
    }
}
