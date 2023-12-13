//  AnswerView.swift

import SwiftUI

struct AnswerView: View {
    let riddle: Riddle
    @Binding var userAnswer: String
    @Binding var isTimeUp: Bool
    @Binding var showAnswer: Bool
    var onNext: () -> Void
    @State private var answerChecked = false
    @State private var userDecisionNeeded = false
    @State private var isCorrect = false
    @State private var isShowResult = false
    @ObservedObject var viewModel: RiddleViewModel

    private var answerComponents: (answer: String, explanation: String) {
        let components = riddle.aiAnswer.split(separator: "。", maxSplits: 1, omittingEmptySubsequences: true)
        let answer = components.first.map(String.init) ?? ""
        let explanation = components.count > 1 ? String(components[1]) : ""
        return (answer: answer, explanation: explanation)
    }

    var body: some View {
        VStack {
            // ユーザーに判断を促すボタン表示
            if isTimeUp {
                ResultMessageView(message: "残念、時間切れです。", isCorrect: false)
                    .onAppear{ isShowResult = true }
            } else if !isCorrect && !answerChecked {
                DecisionButtonsView(answer: riddle.trueAnswer, userAnswer: userAnswer, action: checkAnswer(_:))
            } else {
                ResultMessageView(message: isCorrect ? "正解です！！" : "残念、不正解です。", isCorrect: isCorrect)
                    .onAppear{ isShowResult = true }
            }
            
            Spacer()
            
            ScrollView {
                // 正解、AIの回答、ユーザーの回答を表示
                Divider()
                TrueAnswerView(trueAnswer: riddle.trueAnswer)
                Divider()
                AIAnswerView(answer: answerComponents.answer, explanation: answerComponents.explanation)
                Divider()
                UserAnswerView(userAnswer: userAnswer)
            }
            if isShowResult {
                Button("次へ") {
                    showAnswer = false
                    onNext()
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Capsule().fill(Color.blue).shadow(radius: 10))
            }
        }
        .padding(.bottom, 60)
        .padding()
        .onAppear {
            isCorrect = viewModel.checkUserAnswer(userAnswer, for: riddle)
        }
        .onDisappear {
            isTimeUp = false
            userAnswer = ""
        }
    }
    
    private func checkAnswer(_ userChoiceIsCorrect: Bool) {
        answerChecked = true
        self.isCorrect = userChoiceIsCorrect
        viewModel.updateUserAnswer(for: riddle, isCorrect: userChoiceIsCorrect)
    }
}
