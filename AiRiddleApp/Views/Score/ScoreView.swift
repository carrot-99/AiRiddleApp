//  ScoreView.swift

import SwiftUI

struct ScoreView: View {
    let summary: GameSummary
    let onRetry: () -> Void
    let onHome: () -> Void

    @State private var selectedResult: RiddleResult?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("結果発表")
                    .font(.system(.largeTitle, design: .rounded).weight(.heavy))
                    .padding(.top)

                VersusView(summary: summary)

                if summary.isNewBest {
                    Label("ベスト記録更新！", systemImage: "crown.fill")
                        .font(.headline)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.orange.opacity(0.15)))
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("ふりかえり（タップで答えを確認）")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)

                    ForEach(Array(summary.results.enumerated()), id: \.element.id) { index, result in
                        Button {
                            selectedResult = result
                        } label: {
                            ResultRow(number: index + 1, result: result)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .readableWidth()
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                Button(action: onHome) {
                    Label("TOPへ", systemImage: "house.fill")
                }
                .buttonStyle(SecondaryButtonStyle(color: .blue))

                Button(action: onRetry) {
                    Label("もう一度", systemImage: "arrow.clockwise")
                }
                .buttonStyle(PrimaryButtonStyle(color: .pink))
            }
            .padding()
            .readableWidth()
            .background(.ultraThinMaterial)
        }
        .sheet(item: $selectedResult) { result in
            ResultDetailView(result: result)
        }
    }
}

private struct VersusView: View {
    let summary: GameSummary

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 16) {
                player(name: "あなた", icon: "person.fill", score: summary.correctCount, color: .blue)
                Text("VS")
                    .font(.system(.title2, design: .rounded).weight(.black))
                    .foregroundColor(.secondary)
                player(name: "AI", icon: "cpu", score: summary.aiCorrectCount, color: .purple)
            }

            Text(verdictText)
                .font(.title2.weight(.bold))
                .foregroundColor(verdictColor)
                .multilineTextAlignment(.center)
        }
        .cardStyle()
    }

    private func player(name: String, icon: String, score: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Label(name, systemImage: icon)
                .font(.subheadline.weight(.bold))
                .foregroundColor(color)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("\(score)")
                    .font(.system(size: 48, weight: .heavy, design: .rounded).monospacedDigit())
                Text("/\(summary.total)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private var verdictText: String {
        switch summary.verdict {
        case .win: return "🎉 AIに勝った！"
        case .draw: return "🤝 AIと引き分け"
        case .lose: return "😢 AIの勝ち…つぎはがんばろう！"
        }
    }

    private var verdictColor: Color {
        switch summary.verdict {
        case .win: return .pink
        case .draw: return .orange
        case .lose: return .secondary
        }
    }
}

private struct ResultRow: View {
    let number: Int
    let result: RiddleResult

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: result.outcome.iconName)
                .font(.title3)
                .foregroundColor(result.outcome.color)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text("第\(number)問")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(result.riddle.question)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundColor(.secondary)
        }
        .cardStyle(tint: result.outcome.color)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("第\(number)問 \(result.outcome.message) \(result.riddle.question)")
    }
}
