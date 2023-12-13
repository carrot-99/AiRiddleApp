//  UserAnswerView.swift

import SwiftUI

struct UserAnswerView: View {
    let userAnswer: String

    var body: some View {
        Text("あなたのこたえ")
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .subheadline)
        
        Text(userAnswer)
            .fontWeight(.bold)
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title3)
            .padding()
    }
}
