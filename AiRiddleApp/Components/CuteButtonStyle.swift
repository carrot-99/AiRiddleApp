//  CuteButtonStyle.swift

import Foundation
import SwiftUI

struct CuteButtonStyle: ButtonStyle {
    var bgColor: Color = Color.blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(bgColor)
            .cornerRadius(15)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
