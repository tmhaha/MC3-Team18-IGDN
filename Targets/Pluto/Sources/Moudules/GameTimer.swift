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
    var now: Int {
        get { afterStart }
    }
    
    func startTimer(completion: @escaping (Int) -> () ) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            completion(self.afterStart)
            self.afterStart += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        afterStart = 0
    }
}
