//  DecisionButtonsView.swift

import SwiftUI

struct DecisionButtonsView: View {
    let answer: String
    let userAnswer: String
    let action: (Bool) -> Void

    var body: some View {
        VStack {
            Text("こたえは合っていましたか？")
            HStack {
                Spacer()
                
                CorrectButtonView(
                    action: { action(true) },
                    answerChecked: false,
                    userAnswer: userAnswer,
                    trueAnswer: answer
                )
                
                Spacer()
                
                IncorrectButtonView(
                    action: { action(false) },
                    answerChecked: false,
                    userAnswer: userAnswer,
                    trueAnswer: answer
                )
                Spacer()
            }
            .padding()
        }
    }
}
