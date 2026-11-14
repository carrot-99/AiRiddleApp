//  RiddleView.swift

import SwiftUI

/// 1問分の画面（出題・回答入力・答え合わせ）
struct RiddleView: View {
    @ObservedObject var game: GameViewModel
    let riddle: Riddle
    let onQuit: () -> Void

    @FocusState private var isInputFocused: Bool
    @State private var isShowingQuitAlert = false

    var body: some View {
        VStack(spacing: 12) {
            header
            TimerBarView(remaining: game.timeRemaining, limit: GameViewModel.timeLimit)

            ScrollView {
                VStack(spacing: 16) {
                    QuestionCardView(question: riddle.question)

                    if game.phase == .answering {
                        answerField
                    } else {
                        AnswerView(
                            riddle: riddle,
                            userAnswer: game.currentResult?.userAnswer ?? game.userAnswer,
                            outcome: game.currentResult?.outcome
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.vertical, 4)
                .animation(.spring(response: 0.4, dampingFraction: 0.85), value: game.phase)
            }

            bottomActions
        }
        .padding()
        .readableWidth()
        .background(AppTheme.backgroundGradient.ignoresSafeArea())
        .onAppear {
            game.startTimerIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                if game.phase == .answering { isInputFocused = true }
            }
        }
        .onChange(of: game.phase) { phase in
            if phase != .answering { isInputFocused = false }
        }
        .alert("ゲームをやめますか？", isPresented: $isShowingQuitAlert) {
            Button("やめる", role: .destructive, action: onQuit)
            Button("つづける", role: .cancel) {}
        } message: {
            Text("ここまでの結果は記録されません。")
        }
    }

    // MARK: - Sections

    private var header: some View {
        HStack {
            Button {
                isShowingQuitAlert = true
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(.secondarySystemBackground)))
            }
            .accessibilityLabel("ゲームをやめる")

            Spacer()

            Text("第 \(game.currentIndex + 1) 問")
                .font(.headline)
            Text("/ \(game.riddles.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Label("\(game.correctCount)", systemImage: "checkmark.circle.fill")
                .font(.headline.monospacedDigit())
                .foregroundColor(.green)
                .frame(minWidth: 36)
                .accessibilityLabel("正解数 \(game.correctCount)")
        }
    }

    private var answerField: some View {
        TextField("ここにこたえを入力", text: $game.userAnswer)
            .font(.title3)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isInputFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .focused($isInputFocused)
            .submitLabel(.done)
            .onSubmit(game.submit)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
    }

    @ViewBuilder
    private var bottomActions: some View {
        switch game.phase {
        case .answering:
            VStack(spacing: 10) {
                Button("こたえる", action: game.submit)
                    .buttonStyle(PrimaryButtonStyle(color: .pink))
                    .disabled(!game.canSubmit)
                Button("わからない（スキップ）", action: game.skip)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        case .judging:
            DecisionButtonsView(action: game.judge(isCorrect:))
        case .revealed:
            Button(game.isLastQuestion ? "結果を見る" : "次の問題へ", action: game.next)
                .buttonStyle(PrimaryButtonStyle(color: .blue))
        }
    }
}

// MARK: - Subviews

private struct QuestionCardView: View {
    let question: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("もんだい", systemImage: "questionmark.bubble.fill")
                .font(.subheadline.weight(.bold))
                .foregroundColor(.purple)
            Text(question)
                .font(.title2.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .cardStyle(tint: .purple)
    }
}

private struct TimerBarView: View {
    let remaining: TimeInterval
    let limit: TimeInterval

    private var fraction: Double { max(0, min(1, remaining / limit)) }
    private var seconds: Int { Int(remaining.rounded(.up)) }
    private var color: Color {
        switch remaining {
        case ..<5: return .red
        case ..<10: return .orange
        default: return .blue
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "timer")
                .foregroundColor(color)
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.2))
                    Capsule()
                        .fill(color)
                        .frame(width: proxy.size.width * fraction)
                        .animation(.linear(duration: 0.1), value: fraction)
                }
            }
            .frame(height: 10)
            Text("\(seconds)秒")
                .font(.subheadline.weight(.bold).monospacedDigit())
                .foregroundColor(color)
                .frame(width: 44, alignment: .trailing)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("残り時間 \(seconds)秒")
    }
}
