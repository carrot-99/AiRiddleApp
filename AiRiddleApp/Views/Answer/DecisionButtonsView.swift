//  DecisionButtonsView.swift

import SwiftUI

/// 自動で判定できなかった回答を、ユーザー自身に判定してもらうボタン
struct DecisionButtonsView: View {
    let action: (Bool) -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("あなたのこたえは合っていましたか？")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button { action(true) } label: {
                    Label("合ってた", systemImage: "circle")
                }
                .buttonStyle(PrimaryButtonStyle(color: .green))

                Button { action(false) } label: {
                    Label("ちがった", systemImage: "xmark")
                }
                .buttonStyle(PrimaryButtonStyle(color: .red))
            }
        }
    }
}
