//  AnswerCardView.swift

import SwiftUI

/// 答えと、タップで開ける解説を表示するカード
struct AnswerCardView: View {
    struct Badge {
        let text: String
        let color: Color
    }

    let title: String
    let systemImage: String
    let tint: Color
    let text: AnswerText
    var badge: Badge? = nil

    @State private var isExplanationExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(tint)
                Spacer()
                if let badge {
                    Text(badge.text)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(badge.color))
                }
            }

            Text(text.answer)
                .font(.title3.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)

            if !text.explanation.isEmpty {
                DisclosureGroup(isExpanded: $isExplanationExpanded) {
                    Text(text.explanation)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                } label: {
                    Text("解説を見る")
                        .font(.subheadline)
                }
                .tint(tint)
            }
        }
        .cardStyle(tint: tint)
    }
}
