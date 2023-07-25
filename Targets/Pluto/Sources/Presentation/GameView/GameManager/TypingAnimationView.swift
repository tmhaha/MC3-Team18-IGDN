//
//  TypingAnimationView.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/25.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SwiftUI

struct TypingAnimationView: View {
    let textToType: String
    @State private var typedText: String = ""
    @State private var currentIndex: Int = 0
    
    var body: some View {
        Text(typedText)
            .onAppear {
                startTypingAnimation()
            }
    }
    
    private func startTypingAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if currentIndex < textToType.count {
                typedText += String(textToType[textToType.index(textToType.startIndex, offsetBy: currentIndex)])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}
