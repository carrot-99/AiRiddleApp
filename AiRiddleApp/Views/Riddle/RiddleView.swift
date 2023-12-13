//  RiddleView.swift

import SwiftUI

struct RiddleView: View {
    let riddle: Riddle
    let questionIndex: Int
    let totalQuestions: Int
    var onNext: () -> Void
    @State var showAnswer = false
    @State private var isTimeUp = false
    @Binding var userAnswer: String
    @Binding var secondsElapsed: Int
    @ObservedObject var viewModel: RiddleViewModel
    var timerManager: TimerManager

    var body: some View {
        VStack {
            ProgressView(value: Double(timerManager.secondsElapsed), total: 30)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(maxWidth: .infinity)
            
            if timerManager.secondsElapsed < 30 {
                Text("残り時間: \(30 - timerManager.secondsElapsed) 秒")
                    .font(.headline)
                    .padding()
            } else {
                Text("時間切れ！")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Text("問題 \(questionIndex + 1) / \(totalQuestions)")
                .font(.headline)

            Text(riddle.question)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .title2)
            
            if !showAnswer {
                TextField("あなたの回答", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    timerManager.stopTimer()
                    showAnswer = true
                }) {
                    Text("回答")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.red).shadow(radius: 10))
                }
                .disabled(showAnswer)
                .frame(maxWidth: .infinity)
            } else {
                AnswerView(riddle: riddle, userAnswer: $userAnswer, isTimeUp: $isTimeUp, showAnswer: $showAnswer, onNext: {
                    onNext()
                }, viewModel: viewModel)
                .zIndex(1) // AnswerViewを最前面にする
                .transition(.move(edge: .bottom)) // 任意のトランジションを適用
                .animation(.default, value: showAnswer)
            }
        }
        .onAppear {
            timerManager.startTimer()
        }
        .onReceive(timerManager.$secondsElapsed) { seconds in
            if seconds >= 30 {
                isTimeUp = true
                showAnswer = true
                timerManager.stopTimer()
                viewModel.updateUserAnswer(for: riddle, isCorrect: false)
            }
        }
        .onDisappear {
            timerManager.stopTimer()
        }
        .padding()
    }
}
