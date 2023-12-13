//  TrueAnswerView.swift

import SwiftUI

struct TrueAnswerView: View {
    let trueAnswer: String

    var body: some View {
        Text("こたえ")
            .font(.headline)
        
        Text(trueAnswer)
            .font(.title)
            .fontWeight(.bold)
    }
}
