//  ScoreView.swift

import SwiftUI

struct ScoreView: View {
    var totalQuestions: Int
    var correctAnswers: Int
    @Binding var isTitleViewActive: Bool
    @Binding var isCourseSelectionPresented: Bool
    @ObservedObject var viewModel: RiddleViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("スコア")
                .font(.largeTitle)
                .padding()

            Text("正解数: \(correctAnswers) / \(totalQuestions)")
                .font(.title)

            ScrollView {
                VStack {
                    ForEach(viewModel.riddleResults, id: \.riddle.id) { result in
                        HStack {
                            Image(systemName: result.isCorrect ? "checkmark.circle" : "xmark.circle")
                                .foregroundColor(result.isCorrect ? .green : .red)

                            Text(result.riddle.question)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(result.isCorrect ? Color.green.opacity(0.3) : Color.pink.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        // TODO: タップされたときの振り返り画面への遷移を実装
                    }
                }
            }

            Button("TOPに戻る") {
                isCourseSelectionPresented = false
                isTitleViewActive = true
            }
            .font(.title2)
//            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(Color.blue).shadow(radius: 10))
            .padding(.bottom, 60)
        }
        .padding()
    }
}
