//
//  TypewriterAnimationLabel.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/27.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class TypewriterAnimationLabel: UILabel {
    
    var initText = ""
    private var textToAnimate: String = ""
    private var currentIndex: Int = 0
    private var animationTimer: Timer?
    
    func startTypewriterAnimation() {
        
        self.text = ""
        textToAnimate = initText
        currentIndex = 0
        animationTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLabel() {
        guard currentIndex < textToAnimate.count else {
            stopTypewriterAnimation()
            return
        }
        
        let index = textToAnimate.index(textToAnimate.startIndex, offsetBy: currentIndex)
        let currentCharacter = textToAnimate[index]
        self.text?.append(currentCharacter)
        
        currentIndex += 1
    }
    
    private func stopTypewriterAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

