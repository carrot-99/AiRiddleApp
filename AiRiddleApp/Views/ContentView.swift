//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RiddleViewModel()
    @State private var isCourseSelectionPresented = false
    @State private var isTitleViewActive = true
    @State private var isShowingTerms = true
    @State private var hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")

    var body: some View {
        ZStack(alignment: .bottom) {
            if hasAgreedToTerms {
                NavigationView {
                    if isTitleViewActive {
                        TitleView(isTitleViewActive: $isTitleViewActive)
                    } else {
                        CourseSelectionView(
                            viewModel: viewModel,
                            isCourseSelectionPresented: $isCourseSelectionPresented,
                            isTitleViewActive: $isTitleViewActive
                        )
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    viewModel.initializeDatabaseIfNeeded()
                    viewModel.addNewRiddlesFromCSV()
                }
                
                // 広告を表示
//                AdMobBannerView()
//                    .frame(width: UIScreen.main.bounds.width, height: 50)
//                    .background(Color.gray.opacity(0.1))
            } else {
                // 利用規約とプライバシーポリシーの同意画面
                TermsAndPrivacyAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $hasAgreedToTerms)
            }
        }
    }
}
