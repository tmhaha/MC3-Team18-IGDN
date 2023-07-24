//
//  GameTimer.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/09.
//

import Foundation

class GameTimer {
    
    private var timer: Timer?
    private var afterStart: Int = 0
    private var timingAction: (Int) -> () = { _ in }
    var now: Int {
        get { afterStart }
    }
    
    func startTimer(timeInterval: TimeInterval = 1.0, completion: @escaping (Int) -> ()) {
        timingAction = completion
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            timingAction(self.afterStart)
            self.afterStart += 1
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
