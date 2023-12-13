// CourseRiddlesView.swift

import SwiftUI

struct CourseRiddlesView: View {
    var riddles: [Riddle]
    @State private var currentRiddleIndex = 0
    @State private var userAnswer = ""
    @ObservedObject var viewModel: RiddleViewModel
    @Binding var isTitleViewActive: Bool
    @Binding var isCourseSelectionPresented: Bool

    var body: some View {
        VStack {
            if currentRiddleIndex < riddles.count {
                RiddleView(
                    riddle: riddles[currentRiddleIndex],
                    questionIndex: currentRiddleIndex,
                    totalQuestions: riddles.count,
                    onNext: {
                        currentRiddleIndex += 1
                        userAnswer = ""
                    },
                    userAnswer: $userAnswer, 
                    viewModel: viewModel
                )
            } else {
                ScoreView(
                    totalQuestions: riddles.count,
                    correctAnswers: viewModel.correctAnswerCount,
                    wrongAnswers: viewModel.wrongAnswers,
                    isTitleViewActive: $isTitleViewActive,
                    isCourseSelectionPresented: $isCourseSelectionPresented
                )
            }
        }
    }
}
