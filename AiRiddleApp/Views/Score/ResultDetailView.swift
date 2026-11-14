//  ResultDetailView.swift

import SwiftUI

/// 結果画面から開く、1問ごとのふりかえり
struct ResultDetailView: View {
    let result: RiddleResult

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("もんだい", systemImage: "questionmark.bubble.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.purple)
                        Text(result.riddle.question)
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .cardStyle(tint: .purple)

                    AnswerView(riddle: result.riddle, userAnswer: result.userAnswer, outcome: result.outcome)
                }
                .padding()
                .readableWidth()
            }
            .navigationTitle("ふりかえり")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
