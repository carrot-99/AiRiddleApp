//  TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var isTitleViewActive: Bool

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Group {
                Text("AIに勝てるかな？")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.pink)
                Text("AIなぞなぞ")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Color.purple)
            }
            .padding()
            .shadow(color: .gray, radius: 10, x: 0, y: 5)
            
            Spacer()

            Button(action: {
                 isTitleViewActive = false
             }) {
                 Text("START")
                     .font(.title)
                     .fontWeight(.semibold)
                     .foregroundColor(.white)
                     .padding(.vertical, 15)
                     .frame(maxWidth: .infinity)
                     .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                     .cornerRadius(25)
                     .shadow(color: .gray, radius: 10, x: 0, y: 5)
             }
             .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
    }
}
