//  ResultMessageView.swift

import SwiftUI

struct ResultMessageView: View {
    let message: String
    let isCorrect: Bool

    var body: some View {
        Text(message)
            .foregroundColor(isCorrect ? .green : .red)
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .largeTitle)
            .padding()
    }
}
