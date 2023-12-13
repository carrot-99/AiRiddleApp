// TrueAnswerView.swift

import SwiftUI

struct TrueAnswerView: View {
    let trueAnswer: String
    @State private var showExplanation = false // 解説表示制御のための状態変数

    private var answerComponents: (answer: String, explanation: String) {
        let components = trueAnswer.split(separator: "。", maxSplits: 1, omittingEmptySubsequences: true)
        let answer = components.first.map(String.init) ?? ""
        let explanation = components.count > 1 ? String(components[1]) : ""
        return (answer: answer, explanation: explanation)
    }

    var body: some View {
        VStack {
            Text("こたえ")
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .subheadline)

            Text(answerComponents.answer)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .font(UIDevice.current.userInterfaceIdiom == .pad ? .title : .title3)
                .padding()

            if !answerComponents.explanation.isEmpty {
                Button("解説を見る") {
                    showExplanation.toggle()
                }

                if showExplanation {
                    Text(answerComponents.explanation)
                        .font(UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .callout)
                        .padding()
                }
            }
        }
    }
}
