//  AIAnswerView.swift

import SwiftUI

struct AIAnswerView: View {
    let answer: String
    let explanation: String

    var body: some View {
        VStack {
            Text("AIのこたえ")
                .font(.headline)

            Text(answer)
                .font(.title)
                .fontWeight(.bold)

            if !explanation.isEmpty {
                Text("AIの解説")
                    .font(.headline)
                Text(explanation)
                    .font(.body)
            }
        }
    }
}
