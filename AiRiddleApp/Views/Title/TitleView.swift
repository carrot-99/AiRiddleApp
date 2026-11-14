//  TitleView.swift

import SwiftUI

struct TitleView: View {
    let stats: PlayStats
    let onStart: () -> Void

    @State private var isFloating = false

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .offset(y: isFloating ? -6 : 6)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isFloating)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("AIに勝てるかな？")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(.pink)
                Text("AIなぞなぞ")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.purple)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)

            if stats.playCount > 0 {
                StatsSummaryView(stats: stats)
            }

            Spacer()

            Button(action: {
                Haptics.tap()
                onStart()
            }) {
                Label("スタート", systemImage: "play.fill")
                    .font(.title2.weight(.bold))
            }
            .buttonStyle(PrimaryButtonStyle(color: .blue))
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding()
        .readableWidth()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .onAppear { isFloating = true }
    }
}

private struct StatsSummaryView: View {
    let stats: PlayStats

    var body: some View {
        HStack(spacing: 0) {
            item(value: "\(stats.playCount)", label: "プレイ回数")
            Divider().frame(height: 32)
            item(value: "\(Int((stats.accuracy * 100).rounded()))%", label: "正答率")
            Divider().frame(height: 32)
            item(value: "\(stats.winsAgainstAI)", label: "AIに勝った")
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.8))
        )
        .padding(.horizontal, 24)
    }

    private func item(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}
