//  UserAnswerView.swift

import SwiftUI

struct UserAnswerView: View {
    let userAnswer: String

    var body: some View {
        Text("あなたのこたえ:")
            .font(.headline)
        
        Text(userAnswer)
            .font(.title)
            .fontWeight(.bold)
    }
}
