// CourseRiddlesView.swift

import SwiftUI

struct CourseRiddlesView: View {
    var riddles: [Riddle]
    @State private var currentRiddleIndex = 0
    @State private var userAnswer = ""
    @State private var secondsElapsed = 0
    @State private var timer: Timer? = nil
    @ObservedObject var viewModel: RiddleViewModel
    @Binding var isTitleViewActive: Bool
    @Binding var isCourseSelectionPresented: Bool
    @StateObject var timerManager = TimerManager()

    var body: some View {
        VStack {
            if currentRiddleIndex < riddles.count {
                RiddleView(
                    riddle: riddles[currentRiddleIndex],
                    questionIndex: currentRiddleIndex,
                    totalQuestions: riddles.count,
                    onNext: onNext,
                    userAnswer: $userAnswer,
                    secondsElapsed: $secondsElapsed,
                    viewModel: viewModel,
                    timerManager: timerManager
                )
            } else {
                ScoreView(
                    totalQuestions: riddles.count,
                    correctAnswers: viewModel.correctAnswerCount,
                    isTitleViewActive: $isTitleViewActive,
                    isCourseSelectionPresented: $isCourseSelectionPresented,
                    viewModel: viewModel
                )
            }
        }
    }
    
    private func onNext() {
        resetAndStartTimer()
        currentRiddleIndex += 1
        userAnswer = ""
    }
    
    private func resetAndStartTimer() {
        timerManager.stopTimer()
        timerManager.startTimer()
    }
}
