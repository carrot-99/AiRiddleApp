//  TermsAndPrivacyAgreementView.swift

import SwiftUI

struct TermsAndPrivacyAgreementView: View {
    let onAgree: () -> Void

    @State private var isShowingTerms = false
    @State private var isShowingPrivacyPolicy = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(.purple)
                .accessibilityHidden(true)

            Text("ようこそ「AIなぞなぞ」へ")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)

            Text("本アプリでは、お客様の体験を向上させるために広告を表示します。ご利用の前に、利用規約とプライバシーポリシーをご確認ください。")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 12) {
                documentLink(title: "利用規約", systemImage: "doc.plaintext") {
                    isShowingTerms = true
                }
                documentLink(title: "プライバシーポリシー", systemImage: "hand.raised") {
                    isShowingPrivacyPolicy = true
                }
            }

            Spacer()

            Button("同意してはじめる", action: onAgree)
                .buttonStyle(PrimaryButtonStyle(color: .pink))
        }
        .padding(24)
        .readableWidth()
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .sheet(isPresented: $isShowingTerms) { TermsView() }
        .sheet(isPresented: $isShowingPrivacyPolicy) { PrivacyPolicyView() }
    }

    private func documentLink(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Label(title, systemImage: systemImage)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.secondary)
            }
            .font(.headline)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}

/// 規約・ポリシーなどの文書をシートで表示する共通レイアウト
struct LegalDocumentView: View {
    let title: String
    let sections: [String]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(sections, id: \.self) { section in
                        Text(section)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .readableWidth()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
