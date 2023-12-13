//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var isTitleViewActive: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("AIなぞなぞ")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.pink)
                .padding()
                .shadow(radius: 10)

            Button(action: {
                isTitleViewActive = false
            }) {
                Text("START")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.blue).shadow(radius: 10))
            }
            .padding()
        }
        .padding()
    }
}
