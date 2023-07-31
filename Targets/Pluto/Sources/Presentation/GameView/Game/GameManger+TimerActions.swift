//
//  GameManger+TimerActions.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/29.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

extension GameManager {
    
    func backgroundTimerAction(_ x: Double) {
        let index = Int(x) % 30
        let backgroundNodes = backGround.timeLayer[index]
        scene?.addChilds(backgroundNodes.map { $0 })
        for node in backgroundNodes {
            node.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.5), SKAction.fadeOut(withDuration: 1.5)]).forever)
            let removeAction = SKAction.run {
                node.removeFromParent()
            }
            let sequence = SKAction.sequence([SKAction.moveTo(x: -10, duration: node.duration), removeAction])
            node.run(sequence, withKey: "moveBackground")
        }

    }
}
