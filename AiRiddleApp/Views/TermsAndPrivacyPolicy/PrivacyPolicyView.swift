// PrivacyPolicyView.swift

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(title: "プライバシーポリシー", sections: [
            "1. はじめに\n本プライバシーポリシーは、AIなぞなぞ（以下「本サービス」といいます）における個人情報の取り扱いについて説明します。本サービスでは、ユーザー機能を提供せず、個人情報の収集は行いません。",
            "2. 収集する情報\n本サービスでは、Google AdMobを通じて広告を表示しており、ユーザーの興味に基づいた広告が表示される場合があります。このプロセスで収集されるデータについては、Googleのプライバシーポリシーに準拠します。",
            "3. プライバシーポリシーの変更\n運営者は、必要に応じて本ポリシーを変更することがあります。変更があった場合は、本サービス上で通知します。",
            "4. お問い合わせ\n本プライバシーポリシーに関するお問い合わせは、carrot99.official@gmail.comまでお願いします。",
        ])
    }
}
