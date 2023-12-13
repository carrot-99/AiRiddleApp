//  ScoreView.swift

import SwiftUI

struct ScoreView: View {
    var totalQuestions: Int
    var correctAnswers: Int
    var wrongAnswers: [Riddle]
    @Binding var isTitleViewActive: Bool
    @Binding var isCourseSelectionPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("スコア")
                .font(.largeTitle)
                .padding()

            Text("正解数: \(correctAnswers) / \(totalQuestions)")
                .font(.title)
            
            if !wrongAnswers.isEmpty {
                Text("間違った問題:")
                    .font(.headline)
                    .padding(.top)

                ScrollView {
                    VStack {
                        ForEach(wrongAnswers, id: \.id) { riddle in
                            Text(riddle.question)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.pink.opacity(0.3))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .onTapGesture {
                                    // TODO: タップされたときの振り返り画面への遷移を実装
                                }
                        }
                    }
                }
            }

            Button("TOPに戻る") {
                isCourseSelectionPresented = false
                isTitleViewActive = true
            }
        }
        .padding()
    }
}
