//  AppStyle.swift

import SwiftUI

enum AppTheme {
    /// iPad などの広い画面でも読みやすい最大幅
    static let maxContentWidth: CGFloat = 640

    static let backgroundGradient = LinearGradient(
        colors: [Color(.systemBackground), Color.blue.opacity(0.15)],
        startPoint: .top,
        endPoint: .bottom
    )
}

/// 塗りつぶしのカプセル型ボタン
struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        StyledLabel(configuration: configuration, color: color)
    }

    private struct StyledLabel: View {
        let configuration: Configuration
        let color: Color
        @Environment(\.isEnabled) private var isEnabled

        var body: some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 24)
                .padding(.vertical, 14)
                .padding(.horizontal)
                .background(Capsule().fill(color.opacity(isEnabled ? 1 : 0.35)))
                .shadow(color: color.opacity(isEnabled ? 0.35 : 0), radius: 6, x: 0, y: 3)
                .scaleEffect(configuration.isPressed ? 0.96 : 1)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
        }
    }
}

/// 枠線のみのカプセル型ボタン
struct SecondaryButtonStyle: ButtonStyle {
    var color: Color = .blue

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(color)
            .frame(maxWidth: .infinity, minHeight: 24)
            .padding(.vertical, 14)
            .padding(.horizontal)
            .background(Capsule().fill(Color(.systemBackground)))
            .overlay(Capsule().stroke(color, lineWidth: 2))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    /// 角丸のカード背景
    func cardStyle(tint: Color? = nil) -> some View {
        padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(tint?.opacity(0.12) ?? Color(.secondarySystemBackground))
            )
    }

    /// 広い画面では中央寄せ・最大幅を制限する
    func readableWidth() -> some View {
        frame(maxWidth: AppTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
    }
}
