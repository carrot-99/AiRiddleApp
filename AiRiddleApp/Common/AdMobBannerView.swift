//  AdMobBannerView.swift

import GoogleMobileAds
import SwiftUI

struct AdMobBannerView: UIViewRepresentable {
    static let height: CGFloat = 50

    let adUnitID: String

    /// Info.plist に AdUnitID が設定されている場合のみバナーを表示する
    @ViewBuilder
    static func ifConfigured() -> some View {
        if let id = Bundle.main.object(forInfoDictionaryKey: "AdUnitID") as? String, !id.isEmpty {
            AdMobBannerView(adUnitID: id)
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
        }
    }

    func makeUIView(context: Context) -> GADBannerView {
        let width = UIScreen.main.bounds.width
        let banner = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))
        banner.adUnitID = adUnitID

        let request = GADRequest()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            request.scene = windowScene
            banner.rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController
        }
        banner.load(request)
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
