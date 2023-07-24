//
//  SKNode+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/16.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func runAndRemove(_ action: SKAction, withKey: String = "") {
        
        let finishAction = SKAction.run {
            self.removeFromParent()
        }
        let sequence = SKAction.sequence([action, finishAction])
        run(sequence, withKey: withKey)
    }
    
    func positionFromLeftBottom(_ x: CGFloat, _ y: CGFloat) {
        position = CGPoint(x: x + (frame.width / 2), y: y + (frame.height / 2))
    }
    
    func positionFromLeftMiddle(_ x: CGFloat, _ y: CGFloat) {
        position = CGPoint(x: x + (frame.width / 2), y: y)
    }
}
