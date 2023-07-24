//
//  TempPlanetNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class TempPlanetNode: SKShapeNode {
    
    var id: String = UUID().uuidString
    var gameConstants = GameConstants()
    var delegate: PassRotationingAstronautPointDelegate? = nil
    var status: Status = .none
    var color: AstronautColor = AstronautColor.allCases.randomElement()!
    var astronautNode: AstronautNode? = nil
    var contactPoint: CGPoint = CGPoint()
    var contactNode: SKShapeNode = SKShapeNode()
    var astronaut = AstronautNode(color: .clear, size: CGSize(width: 30, height: 30))
    var directionNode: [SKShapeNode] = []
    
    func startDirectionNodesRotation() {
        
        for i in 0...3 {
            let node = SKShapeNode(path: TempPlanetNode.createTrianglePath(width: 10, height: 10))
            node.zRotation = CGFloat.pi / 2
            node.fillColor = .clear
            node.strokeColor = .clear
            self.addChild(node)
            node.run(SKAction.follow(self.path!, asOffset: false, orientToPath: true, duration: 0.5).forever)
            DispatchQueue.global().asyncAfter(deadline: .now() + (0.5 * (0.25 * Double(i)))) {
                node.fillColor = .white
                node.speed = 0.1
            }
          
            directionNode.append(node)
        }
    }
    
    
    
    func startRotation(at point: CGPoint, thatNodePoint: AstronautNode) {
        
        let followAction = SKAction.follow(path!, asOffset: false, orientToPath: true, duration: gameConstants.planetFindContactPointDuration)
        followAction.timingFunction = timingFunc
        
        contactPoint = orginPointToNodePoint(at: point, to: thatNodePoint.position, nodeSize: self.frame.size)
        contactNode = SKShapeNode(path: TempPlanetNode.createCirclePath(center: CGPoint(x: point.x - position.x, y: point.y - position.y), radius: 20))
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
        astronaut.id = id
        
        return astronaut
    }
}

extension TempPlanetNode {
    
    private func timingFunc(_ timing: Float) -> Float {
        if astronaut.color == astronautNode!.color {
            delegate?.passAstronautPoint(at: CGPoint(x: position.x + astronaut.position.x, y: position.y + astronaut.position.y))
        }
        if contactNode.path!.contains(astronaut.position) {
            
            astronaut.color = astronautNode!.color
            astronaut.speed = gameConstants.planetOrbitDuration
            return timing
        }
        
        return timing
    }
    
    static func createSquarePath() -> CGPath {
        let size = CGSize(width: 100, height: 100)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 20)
        return path.cgPath
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
    
    static func createRoundedStarPath(cornerRadius: CGFloat = 20, width: CGFloat = 100, height: CGFloat = 100) -> CGPath {
        let path = UIBezierPath()
        
        let center = CGPoint(x: width/2, y: height/2)
        let numberOfPoints = 5
        let angle = 4 * CGFloat.pi / CGFloat(numberOfPoints)
        let outerRadius = min(width, height) / 2
        let innerRadius = outerRadius * cos(angle/2) / cos(2 * angle)
        
        for i in 0..<(numberOfPoints * 2) {
            let currentAngle = CGFloat(i) * angle - CGFloat.pi / 2
            let radius = (i % 2 == 0) ? outerRadius : innerRadius
            
            let x = center.x + radius * cos(currentAngle)
            let y = center.y + radius * sin(currentAngle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.close()
        
        let roundedPath = path.cgPath.copy(strokingWithWidth: cornerRadius, lineCap: .butt, lineJoin: .round, miterLimit: 0)
        
        return roundedPath
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
extension TempPlanetNode {
    enum Status {
        case none
        case rotationing
    }
}

