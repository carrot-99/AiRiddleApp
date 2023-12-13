//  RiddleView.swift

import SwiftUI

struct RiddleView: View {
    let riddle: Riddle
    let questionIndex: Int
    let totalQuestions: Int
    var onNext: () -> Void
    @State private var showAnswer = false
    @Binding var userAnswer: String
    @ObservedObject var viewModel: RiddleViewModel

    var body: some View {
        VStack {
            Text("問題 \(questionIndex + 1) / \(totalQuestions)")
                .font(.headline)
                .padding()

            Text(riddle.question)
                .font(.title)
                .padding()
            
            TextField("あなたの回答", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("答えを見る") {
                showAnswer = true
            }
            .fullScreenCover(isPresented: $showAnswer) {
                AnswerView(
                    riddle: riddle,
                    userAnswer: userAnswer,
                    showAnswer: $showAnswer,
                    onNext: {
                        self.userAnswer = ""
                        onNext()
                    },
                    viewModel: viewModel
                )
            }
        }
        .padding()
    }
}
