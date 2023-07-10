//
//  AstronautNode.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/08.
//

import SpriteKit

class AstronautNode: SKSpriteNode {
    
    var astronautColor: AstronautColor = .none {
        willSet(newValue) {
            print(newValue)
            color = newValue.color
        }
    }
    
    func startGame() {
        self.color = astronautColor.color
        startFoward()
    }
}

// MARK: - AstronautStatus
extension AstronautNode {
}


// MARK: - Moving Actions
extension AstronautNode {
    
    var moveFowardAction: SKAction {
        let currentVector = raidanToVector(radians: zRotation, distance: 100)
        return SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 1).forever
    }
    
    func startFoward() {
        run(moveFowardAction, withKey: "moveFowardAction")
    }
    
    func startTurnClockwise() {
        
        removeAction(forKey: "moveFowardAction")
        var sequences: [SKAction] = []
        var angle = 0.0
        
        for _ in 0...1000 {
            
            let currentVector = raidanToVector(radians: zRotation + angle, distance: 10)
            angle += (CGFloat.pi / 30)
            
            let moveAction = SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 0.1)
            let rotateAction = SKAction.rotate(byAngle: (CGFloat.pi / 30), duration: 0.1)
            
            let group = SKAction.group([moveAction, rotateAction])
            sequences.append(group)
        }
        let action = SKAction.sequence(sequences)
        
        self.run(action, withKey: "turnClockwise")
    }
    
    func endTurnClockwise() {
        self.removeAction(forKey: "turnClockwise")
        startFoward()
    }
    
    func StartTurnCounterClockwise() {
        
        removeAction(forKey: "moveFowardAction")
        var sequences: [SKAction] = []
        var angle = 0.0
        
        for _ in 0...1000 {
            
            let currentVector = raidanToVector(radians: zRotation - angle, distance: 10)
            angle += (CGFloat.pi / 30)
            
            let moveAction = SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 0.1)
            let rotateAction = SKAction.rotate(byAngle: -(CGFloat.pi / 30), duration: 0.1)
            
            let group = SKAction.group([moveAction, rotateAction])
            sequences.append(group)
        }
        let action = SKAction.sequence(sequences)
        
        self.run(action, withKey: "turnCounterClockwise")
    }
    
    func endTurnCounterClockwise() {
        self.removeAction(forKey: "turnCounterClockwise")
        startFoward()
    }
}


extension AstronautNode {
    
    func raidanToVector(radians: CGFloat, distance: CGFloat) -> CGVector {
        let degrees = radians * (180.0 / .pi)
        let radians = degrees * (.pi / 180.0)
        let dx = cos(radians)
        let dy = sin(radians)
        let vector = CGVector(dx: dx * distance, dy: dy * distance)
        return vector
    }
}

