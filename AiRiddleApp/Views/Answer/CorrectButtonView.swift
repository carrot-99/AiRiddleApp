//  CorrectButtonView.swift

import SwiftUI

struct CorrectButtonView: View {
    var action: () -> Void
    var answerChecked: Bool
    var userAnswer: String
    var trueAnswer: String

    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .foregroundColor(!answerChecked ? .white : (userAnswer == trueAnswer ? .white : .gray))
                .padding()
                .background(!answerChecked ? Color.green : (userAnswer == trueAnswer ? Color.green : Color.green.opacity(0.5)))
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .disabled(answerChecked)
    }
}
