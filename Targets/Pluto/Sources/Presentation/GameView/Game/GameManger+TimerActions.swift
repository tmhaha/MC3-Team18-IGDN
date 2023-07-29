//
//  GameManger+TimerActions.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/29.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

extension GameManager {
    
    func gameTimerAction(_ x: Double) {
        
        if ObstacleIndex >= map.count {
            //            gameTimer.stopTimer()
            //            scene?.isPaused = true
            //            delegate?.showAlert(alertType: .success)
        }
        else {
            while ObstacleIndex < map.count && Double(plentTime) > map[ObstacleIndex].point.x {
                let currentData = map[ObstacleIndex]
                let planet = currentData.makePlanetNode()
                planet.delegate = self
                scene?.addChild(planet)
                planet.startDirectionNodesRotation()
                planet.runAndRemove(SKAction.moveTo(x: -150, duration: gameConstants.planetDuration))
                
                ObstacleIndex += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [self] in
                    let percent = CGFloat(self.ObstacleIndex) / CGFloat(self.map.count)
                    self.nodes.topProgressBar.percent = percent
                    self.nodes.bottomProgressBar.percent = percent
                }
                if ObstacleIndex > 0 {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.scene?.isUserInteractionEnabled = true
                        self.nodes.astronaut.startGame()
                    }
                }
            }
        }
        plentTime += 1
    }
    
    func backgroundTimerAction(_ x: Double) {
        let index = Int(x) % 30
        
        let backgroundNodes = backGround.timeLayer[index]
        scene?.addChilds(backgroundNodes.map { $0 })
        for node in backgroundNodes {
            node.run(SKAction.sequence([SKAction.fadeIn(withDuration: 1.5), SKAction.fadeOut(withDuration: 1.5)]).forever)
            node.runAndRemove(SKAction.moveTo(x: -10, duration: node.duration), withKey: "moveBackground")
        }
    }
}
