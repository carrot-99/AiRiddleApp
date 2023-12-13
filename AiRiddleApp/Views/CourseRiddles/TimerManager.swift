//  TimerManager.swift

import Foundation

class TimerManager: ObservableObject {
    @Published var secondsElapsed: Int = 0
    private var timer: Timer?

    func startTimer() {
        timer?.invalidate()
        secondsElapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.secondsElapsed < 30 {
                self.secondsElapsed += 1
            } else {
                self.timer?.invalidate()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
