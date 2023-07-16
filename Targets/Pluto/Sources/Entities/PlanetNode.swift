//
//  PlanetNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class PlanetNode: SKShapeNode {
    
    var status: Status = .none
    var color: AstronautColor = AstronautColor.allCases.randomElement()!
    var astronautNode: AstronautNode? = nil
    var contactPoint: CGPoint = CGPoint()
    var contactNode: SKShapeNode = SKShapeNode()
    var astronaut = AstronautNode(color: .clear, size: CGSize(width: 30, height: 30))
    
    func startRotation(at point: CGPoint, thatNodePoint: AstronautNode) {
        
        let followAction = SKAction.follow(path!, asOffset: false, orientToPath: true, duration: GameConstans.planetFindContactPointDuration)
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
        astronaut.zRotation = astronaut.zRotation + CGFloat.pi/2
        astronaut.position = CGPoint(x: position.x + astronaut.position.x, y: position.y + astronaut.position.y )
        
        return astronaut
    }
    
}

extension PlanetNode {
    
    private func timingFunc(_ timing: Float) -> Float {
        
        if contactNode.path!.contains(astronaut.position) {
            
            astronaut.color = astronautNode!.color
            astronaut.speed = GameConstans.planetOrbitDuration
            return timing
        }
        else {
            
        }
        
        return timing
    }
    
    func createCircularNode(at point: CGPoint, radius: CGFloat, color: UIColor) -> (SKNode, CGPath) {
        let node = SKNode()
        
        let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        let shapeNode = SKShapeNode(path: path.cgPath)
        shapeNode.strokeColor = color
        shapeNode.fillColor = UIColor.clear
        
        node.addChild(shapeNode)
        
        return (node, path.cgPath)
    }
    
    private func orginPointToNodePoint(at origin: CGPoint, to nodePoint: CGPoint, nodeSize: CGSize) -> CGPoint {
        let nodeCenterPoint = CGPoint(x: nodePoint.x + (nodeSize.width / 2), y: nodePoint.y + (nodeSize.height / 2))
        let answer = CGPoint(x: origin.x - nodeCenterPoint.x, y: origin.y - nodeCenterPoint.y)
        
        return answer
    }
    
    private func nodePointToOriginPoint(at nodePoint: CGPoint, in thatPoint: CGPoint, nodeSize: CGSize) -> CGPoint {
        let nodeCenterPoint = CGPoint(x: nodePoint.x + (nodeSize.width / 2), y: nodePoint.y + (nodeSize.height / 2))
        let answer = CGPoint(x: nodeCenterPoint.x + thatPoint.x, y: nodeCenterPoint.y + thatPoint.y)
        
        return answer
    }
    
    private func positionToCenter(at point: CGPoint, nodeSize: CGSize) -> CGPoint {
        CGPoint(x: point.x - (nodeSize.width / 2), y: point.y - (nodeSize.height / 2))
    }
    
    static func createCirclePath(center: CGPoint, radius: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = .pi * 2
        let clockwise: Bool = false
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return path
    }
    
    func createCircularNode(radius: CGFloat, color: UIColor) -> SKNode {
        let node = SKNode()
        
        let shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = color
        
        node.addChild(shapeNode)
        
        return node
    }
    
    func createSquarePath(point1: CGPoint, point2: CGPoint) -> CGPath {
        let minX = min(point1.x, point2.x)
        let maxX = max(point1.x, point2.x)
        let minY = min(point1.y, point2.y)
        let maxY = max(point1.y, point2.y)
        
        let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        let path = UIBezierPath(rect: rect)
        
        return path.cgPath
    }
}

/// STATUS
extension PlanetNode {
    enum Status {
        case none
        case rotationing
    }
}
