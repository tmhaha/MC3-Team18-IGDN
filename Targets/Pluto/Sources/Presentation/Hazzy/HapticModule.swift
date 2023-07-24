//
//  HapticModule.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/07.
//

import SwiftUI

enum HapticStyle {
    case heavy
    case light
    case medium
    case rigid
    case soft
}

func hapticFeedback(style: HapticStyle = .medium, duration: Double = 0.1, interval: Double = 0.1) {
    let feedbackGenerator: UIImpactFeedbackGenerator
    
    switch style {
    case .heavy:
        feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    case .light:
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    case .medium:
        feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    case .rigid:
        feedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    case .soft:
        feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    }

    feedbackGenerator.prepare()

    var timer: Timer?
    var elapsedTime = 0.0

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
        feedbackGenerator.impactOccurred()
        elapsedTime += interval

        if elapsedTime >= duration {
            timer?.invalidate()
        }
    }
    
//    RunLoop.current.add(timer!, forMode: .common)
}
