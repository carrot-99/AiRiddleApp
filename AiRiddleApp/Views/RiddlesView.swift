//  RiddlesView.swift
//
//import SwiftUI
//
//struct RiddlesView: View {
//    @ObservedObject var viewModel: RiddleViewModel
//
//    var body: some View {
//        VStack {
//            List(viewModel.riddles) { riddle in
//                NavigationLink(destination: RiddleView(riddle: riddle)) {
//                    Text(riddle.question)
//                        .font(.headline)
//                }
//            }
//            .navigationTitle("なぞなぞリスト")
//        }
//    }
//}
