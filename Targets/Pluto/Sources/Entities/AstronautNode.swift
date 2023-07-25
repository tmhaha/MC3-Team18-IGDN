//
//  AstronautNode.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/08.
//

import SpriteKit

class AstronautNode: SKSpriteNode {
    
    var id: String = UUID().uuidString
    var gameConstants: GameConstants = GameConstants()
    var status: Status = .none
    var orbitPlanet: PlanetNode? = nil
    
    var type: AstronautColor = .none {
        willSet(newValue) {
            color = newValue.color
        }
    }
    
    func startGame() {
        self.color = type.color
        startFoward()
    }
}

// MARK: - AstronautStatus
extension AstronautNode {
    enum Status {
        case inOribt
        case none
    }
}


// MARK: - Moving Actions
extension AstronautNode {
    
    var moveFowardAction: SKAction {
        let currentVector = raidanToVector(radians: zRotation, speed: gameConstants.astronautSpeed)
        return SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 1).forever
    }
    
    func startFoward() {
        run(moveFowardAction, withKey: "moveFowardAction")
    }
    
    func startTurnClockwise() {
        
        removeAction(forKey: "moveFowardAction")
        if action(forKey: "turnCounterClockwise") != nil {
            return
        }
        var sequences: [SKAction] = []
        var angle = 0.0
        
        for _ in 0...1000 {
            
            let currentVector = raidanToVector(radians: zRotation + angle, speed: 20)
            angle += gameConstants.astronuatAngle
            
            let moveAction = SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 0.1)
            let rotateAction = SKAction.rotate(byAngle: (gameConstants.astronuatAngle), duration: 0.1)
            
            let group = SKAction.group([moveAction, rotateAction])
            sequences.append(group)
        }
        let action = SKAction.sequence(sequences)
        
        self.run(action, withKey: "turnClockwise")
    }
    
    func endTurnClockwise() {
        if action(forKey: "turnClockwise") != nil {
            self.removeAction(forKey: "turnClockwise")
            startFoward()
        }
    }
    
    func startTurnCounterClockwise() {
        
        removeAction(forKey: "moveFowardAction")
        if action(forKey: "turnClockwise") != nil {
            return
        }
        var sequences: [SKAction] = []
        var angle = 0.0
        
        for _ in 0...1000 {
            
            let currentVector = raidanToVector(radians: zRotation - angle, speed: 20)
            angle += gameConstants.astronuatAngle
            
            let moveAction = SKAction.moveBy(x: currentVector.dx, y: currentVector.dy, duration: 0.1)
            let rotateAction = SKAction.rotate(byAngle: -(gameConstants.astronuatAngle), duration: 0.1)
            
            let group = SKAction.group([moveAction, rotateAction])
            sequences.append(group)
        }
        let action = SKAction.sequence(sequences)
        
        self.run(action, withKey: "turnCounterClockwise")
    }
    
    func endTurnCounterClockwise() {
        if action(forKey: "turnCounterClockwise") != nil {
            self.removeAction(forKey: "turnCounterClockwise")
            startFoward()
        }
    }
    
    func raidanToVector(radians: CGFloat, speed: CGFloat) -> CGVector {
        let degrees = radians * (180.0 / .pi)
        let radians = degrees * (.pi / 180.0)
        let dx = cos(radians)
        let dy = sin(radians)
        let vector = CGVector(dx: dx * speed, dy: dy * speed)
        return vector
    }
}
