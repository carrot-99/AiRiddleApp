// CourseSelectionView.swift

import SwiftUI

struct CourseSelectionView: View {
    @ObservedObject var viewModel: RiddleViewModel
    @Binding var isCourseSelectionPresented: Bool
    @Binding var isTitleViewActive: Bool
    @State private var selectedCourse: [Riddle]?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("コースを選択してください")
                .font(.title)
                .padding()

            Button(action: {
                viewModel.resetGame()
                self.selectedCourse = viewModel.getRandomRiddles(count: 10)
                isCourseSelectionPresented = true
            }) {
                Text("10問コース")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.green).shadow(radius: 10))
            }

            Button(action: {
                viewModel.resetGame()
                self.selectedCourse = viewModel.getRandomRiddles(count: 20)
                isCourseSelectionPresented = true
            }) {
                Text("20問コース")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color.red).shadow(radius: 10))
            }

            Spacer()
        }
        .padding()
        .background(
            NavigationLink(
                destination: CourseRiddlesView(
                    riddles: selectedCourse ?? [],
                    viewModel: viewModel,
                    isTitleViewActive: $isTitleViewActive,
                    isCourseSelectionPresented: $isCourseSelectionPresented
                ),
                isActive: $isCourseSelectionPresented
            ) { EmptyView() }.hidden()
        )
    }
}
