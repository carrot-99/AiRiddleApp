//  IncorrectButtonView.swift

import SwiftUI

struct IncorrectButtonView: View {
    var action: () -> Void
    var answerChecked: Bool
    var userAnswer: String
    var trueAnswer: String

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(!answerChecked ? .white : (userAnswer != trueAnswer ? .white : .gray))
                .padding()
                .background(!answerChecked ? Color.red : (userAnswer != trueAnswer ? Color.red : Color.red.opacity(0.5)))
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .disabled(answerChecked)
    }
}
