//  AnswerView.swift

import SwiftUI

struct AnswerView: View {
    let riddle: Riddle
    let userAnswer: String
    @Binding var showAnswer: Bool
    var onNext: () -> Void
    @State private var answerChecked = false
    @State private var userDecisionNeeded = false
    @State private var isCorrect: Bool? = nil
    @ObservedObject var viewModel: RiddleViewModel
    
    private var answerComponents: (answer: String, explanation: String) {
        let components = riddle.aiAnswer.split(separator: "。", maxSplits: 1, omittingEmptySubsequences: true)
        let answer = components.first.map(String.init) ?? ""
        let explanation = components.count > 1 ? String(components[1]) : ""

        return (answer: answer, explanation: explanation)
    }

    var body: some View {
        VStack {
            
            TrueAnswerView(trueAnswer: riddle.trueAnswer)
            
            Divider()
            
            AIAnswerView(answer: answerComponents.answer, explanation: answerComponents.explanation)

            Divider()
            
            UserAnswerView(userAnswer: userAnswer)
            
            if userDecisionNeeded {
                if !answerChecked {
                    DecisionButtonsView(
                        answer: riddle.trueAnswer,
                        userAnswer: userAnswer,
                        action: checkAnswer(_:)
                    )
                }

                if let isCorrect = isCorrect {
                    ResultMessageView(isCorrect: isCorrect)
                }
            }
            
            if let isCorrect = isCorrect {
                Text(isCorrect ? "正解！おめでとうございます！" : "残念、不正解です。")
                    .font(.headline)
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
            }

            Spacer()
            Button("次へ") {
                showAnswer = false
                onNext()
            }
        }
        .padding()
        .onAppear {
            isCorrect = viewModel.checkUserAnswer(userAnswer, for: riddle)
        }
    }
    
    private func checkAnswer(_ isCorrect: Bool) {
        answerChecked = true
        self.isCorrect = isCorrect
        if isCorrect {
            viewModel.correctAnswerCount += 1
        } else {
            viewModel.wrongAnswers.append(riddle)
        }
    }
}
