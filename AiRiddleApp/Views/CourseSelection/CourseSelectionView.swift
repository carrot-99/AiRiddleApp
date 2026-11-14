// CourseSelectionView.swift

import SwiftUI

struct CourseSelectionView: View {
    let availableCount: Int
    let stats: PlayStats
    let onSelect: (Course) -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    Label("もどる", systemImage: "chevron.left")
                        .font(.headline)
                }
                Spacer()
            }
            .padding(.horizontal)

            Text("コースをえらんでね")
                .font(.system(.title, design: .rounded).weight(.bold))
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Course.allCases) { course in
                        CourseCard(
                            course: course,
                            questionCount: min(course.questionCount, availableCount),
                            bestScore: stats.bestScore(for: course)
                        ) {
                            Haptics.tap()
                            onSelect(course)
                        }
                        .disabled(availableCount == 0)
                    }

                    Label("1問 \(Int(GameViewModel.timeLimit)) 秒以内にこたえよう！", systemImage: "timer")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    if availableCount == 0 {
                        Text("問題を読み込めませんでした。アプリを再起動してください。")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                // カードの影がスクロール領域で切れないよう、内側に余白をとる
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
        }
        .padding(.vertical)
        .readableWidth()
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
    }
}

private struct CourseCard: View {
    let course: Course
    let questionCount: Int
    let bestScore: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: course.iconName)
                    .font(.title)
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.title3.weight(.bold))
                    Text(course.subtitle)
                        .font(.subheadline)
                        .opacity(0.9)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("ベスト")
                        .font(.caption2)
                        .opacity(0.85)
                    Text(bestScore.map { "\($0)/\(questionCount)" } ?? "--")
                        .font(.headline.monospacedDigit())
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(
                        colors: [course.color, course.color.opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .shadow(color: course.color.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(course.title)、\(questionCount)問、ベスト \(bestScore.map(String.init) ?? "なし")")
    }
}
