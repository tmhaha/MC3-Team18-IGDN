//
//  GameTimer.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/09.
//

import Foundation

class GameTimer {
    
    private var timer: Timer?
    private var afterStart: Double = 0
    var timeInterval: Double
    private var timingAction: (Double) -> () = { _ in }
    var now: Double {
        get { afterStart }
    }
    
    init(timeInterval: Double) {
        self.timeInterval = timeInterval
    }
    
    func startTimer(completion: @escaping (Double) -> ()) {
        timingAction = completion
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            timingAction(self.afterStart)
            self.afterStart += timeInterval
        }
    }
    
    func restartTimer() {
        startTimer(completion: timingAction)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        afterStart = 0
    }
}
