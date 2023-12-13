//  ResultMessageView.swift

import SwiftUI

struct ResultMessageView: View {
    let isCorrect: Bool

    var body: some View {
        Text(isCorrect ? "正解！おめでとうございます！" : "残念、不正解です。")
            .font(.headline)
            .foregroundColor(isCorrect ? .green : .red)
            .padding()
    }
}
