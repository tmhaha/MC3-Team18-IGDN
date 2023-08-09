//
//  PlanetNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class PlanetNode: SKSpriteNode {
    
    var isInScreen = false
    var id: String = UUID().uuidString
    var gameConstants = GameConstants()
    var delegate: PassRotationingAstronautPointDelegate? = nil
    var status: Status = .none
    var astronautColor: AstronautColor = .none
    var astronautNode: AstronautNode? = nil
    var contactPoint: CGPoint = CGPoint()
    var contactNode: SKShapeNode = SKShapeNode()
    var astronaut = AstronautNode(color: .clear, size: CGSize(width: 30, height: 30))
    var directionNode: [SKShapeNode] = []
    var path: CGPath = CGPath(ellipseIn: .zero, transform: nil)
    var isClockWise = true
    var tutorials: [GameAlertType] = []
    var checkposition = false
    
    func startDirectionNodesRotation() {
        
        for i in 0...3 {
            let node = SKShapeNode(path: PlanetNode.createTrianglePath(width: 10, height: 10))
            if !isClockWise {
                node.zRotation = -CGFloat.pi / 2
            }
            else {
                node.zRotation = CGFloat.pi / 2
            }
            node.fillColor = .clear
            node.strokeColor = .clear
            self.addChild(node)
            node.run(SKAction.follow(path, asOffset: false, orientToPath: true, duration: 0.5).forever)
            DispatchQueue.global().asyncAfter(deadline: .now() + (0.5 * (0.25 * Double(i)))) {
                node.fillColor = .white
                node.speed = 0.1
            }
          
            directionNode.append(node)
        }
    }
    
    
    
    func startRotation(at point: CGPoint, thatNodePoint: AstronautNode) {
        let followAction = SKAction.follow(path, asOffset: false, orientToPath: true, duration: gameConstants.planetFindContactPointDuration)
        followAction.timingFunction = timingFunc
        
        contactPoint = orginPointToNodePoint(at: point, to: thatNodePoint.position, nodeSize: self.frame.size)
        contactNode = SKShapeNode(path: PlanetNode.createCirclePath(center: CGPoint(x: point.x - position.x, y: point.y - position.y), radius: 20))
        contactNode.fillColor = .clear
        contactNode.strokeColor = .clear
        
        astronautNode = thatNodePoint
        
        addChild(astronaut)
        astronaut.run(SKAction.repeatForever(followAction), withKey: "followAction")
        
        addChild(contactNode)
    }
    
    func changedColor(to color: AstronautColor) -> AstronautNode {
        astronaut.type = color
        astronaut.removeAction(forKey: "followAction")
        astronaut.removeFromParent()
        astronaut.speed = 1
        astronaut.zRotation += CGFloat.pi / 2
        astronaut.position = CGPoint(x: position.x + astronaut.position.x, y: position.y + astronaut.position.y )
        astronaut.id = id
        
        let astronautPath = UIBezierPath()
        astronautPath.move(to: CGPoint(x: -7.49, y: 0))
        astronautPath.addLine(to: CGPoint(x: -9.49, y: 7.12))
        astronautPath.addLine(to: CGPoint(x: 8.41, y: 0))
        astronautPath.addLine(to: CGPoint(x: -9.49, y: -7.12))
        astronautPath.close()
        
        astronaut.physicsBody = SKPhysicsBody(polygonFrom: astronautPath.cgPath)
        astronaut.physicsBody?.categoryBitMask = 1
        astronaut.physicsBody?.contactTestBitMask = 4 | 2
        
        
        return astronaut
    }
}

extension PlanetNode {
    
    private func timingFunc(_ timing: Float) -> Float {
        
        if checkposition && astronaut.color == astronautNode!.color {
            delegate?.passAstronautPoint(at: CGPoint(x: position.x + astronaut.position.x, y: position.y + astronaut.position.y))
        }
        if contactNode.path!.contains(astronaut.position) {
            checkposition = true
            let newTexture = SKTexture(imageNamed: astronautColor.imageName + "CW")
            astronaut.texture = newTexture
            astronaut.speed = gameConstants.planetOrbitDuration
            return timing
        }
        
        return timing
    }
    
    private func orginPointToNodePoint(at origin: CGPoint, to nodePoint: CGPoint, nodeSize: CGSize) -> CGPoint {
        let nodeCenterPoint = CGPoint(x: nodePoint.x + (nodeSize.width / 2), y: nodePoint.y + (nodeSize.height / 2))
        let answer = CGPoint(x: origin.x - nodeCenterPoint.x, y: origin.y - nodeCenterPoint.y)
        
        return answer
    }
    
  
    static func createCirclePath(center: CGPoint, radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = .pi * 2
        let clockwise: Bool = false
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return path
    }
    
    static func createTrianglePath(width: CGFloat, height: CGFloat) -> CGPath {
        let path = CGMutablePath()
        
        let pointA = CGPoint(x: -5, y: -5)
        let pointB = CGPoint(x: width - 5, y: -5)
        let pointC = CGPoint(x: -5 + width / 2, y: height - 5)
        
        path.move(to: pointA)
        path.addLine(to: pointB)
        path.addLine(to: pointC)
        path.closeSubpath()
        
        return path.copy()! // copy() 메서드를 사용하여 mutable path를 immutable한 path로 변환하여 리턴합니다.
    }
    
    func createCircularNode(radius: CGFloat, color: UIColor) -> SKNode {
        let node = SKNode()
        
        let shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = color
        
        node.addChild(shapeNode)
        
        return node
    }
    
    
}

/// STATUS
extension PlanetNode {
    enum Status {
        case none
        case rotationing
    }
}

