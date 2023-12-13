//  AIAnswerView.swift

import SwiftUI

struct AIAnswerView: View {
    let answer: String
    let explanation: String
    @State private var showExplanation = false // 解説表示制御のための状態変数

    var body: some View {
        VStack {
            Text("AIのこたえ")
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .subheadline)

            Text(answer)
                .fontWeight(.bold)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title3)
                .padding()

            if !explanation.isEmpty {
                Button("AIの解説を見る") {
                    showExplanation.toggle()
                }

                if showExplanation {
                    Text(explanation)
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .callout)
                        .padding()
                }
            }
        }
    }
}
