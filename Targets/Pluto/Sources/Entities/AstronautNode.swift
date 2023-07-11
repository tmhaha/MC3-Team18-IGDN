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
        let currentVector = raidanToVector(radians: zRotation, speed: 100)
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
            
            let currentVector = raidanToVector(radians: zRotation + angle, speed: 10)
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
            
            let currentVector = raidanToVector(radians: zRotation - angle, speed: 10)
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

// MARK: - 행성궤도를 공전하며 x축 이동의 힘 합성을 위한 함수들
extension AstronautNode {
    
    func inPlanetaryOrbit(planet: TimeInterval,
                          astronaut: TimeInterval,
                          p1: CGPoint,
                          path: CGPath,
                          leftCount: Int = 1000,
                          completion: @escaping (CGPoint, Int) -> Void) {
        
        if leftCount > 0 {
            let p2 = nextPoint(at: p1, path: path)
            let theta = calculateRadianBetween(point1: p1, and: p2)
            let planetSpeed = convertTimeIntervalToSpeed(timeInterval: planet)
            let astronautSpeed = convertTimeIntervalToSpeed(timeInterval: astronaut)
            let x = planetSpeed + (astronautSpeed * cos(theta))
            let y = astronautSpeed * sin(theta)
            
            let moveAction = SKAction.moveBy(x: x, y: y, duration: 0.1)
            let rotateAction = SKAction.rotate(byAngle:theta, duration: 0.1)
            
            
            let group = SKAction.group([moveAction, rotateAction])
            let run = SKAction.run { completion(CGPoint(x: x,y: y), leftCount-1) }
            let sequence = SKAction.sequence([group])
            
            DispatchQueue.global().sync {
                DispatchQueue.main.async {
                    self.run(group, withKey: "inOrbit")
                }
            }
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
    
    /// path에 속하는 한 점과 미분을 통해 구해진 다음 점을 배출
    func nextPoint(at point: CGPoint, path: CGPath) -> CGPoint {
        let candidates = roundPoints(center: point)
        var answer = CGPoint()
        print(candidates)
        
        for i in 0 ..< candidates.count - 1 {
            if path.contains(candidates[i]) == true && path.contains(candidates[i+1]) == false {
                answer = midPointBetween(point1: candidates[i], and: candidates[i+1])
            }
            else if path.contains(candidates[i]) == false && path.contains(candidates[i+1]) == true {
                answer = midPointBetween(point1: candidates[i], and: candidates[i+1])
            }
        }
        
        return answer
    }
    
    /// 미분을 위한 접점과 그 주변의 점들
    func roundPoints(center: CGPoint, radius: CGFloat = 5, count: Int = 3600) -> [CGPoint] {
        let path = UIBezierPath()
        let increment = CGFloat.pi * 2 / CGFloat(count)
        var answers: [CGPoint] = []
        
        for i in 0..<count {
            let angle = increment * CGFloat(i)
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            path.move(to: point)
            
            answers.append(point)
        }
        
        return answers
    }
    
    /// 미분의 정확성을 위한 두 점과 그 사잇점 배출
    func midPointBetween(point1: CGPoint, and point2: CGPoint) -> CGPoint {
        let midX = (point1.x + point2.x) / 2.0
        let midY = (point1.y + point2.y) / 2.0
        
        return CGPoint(x: midX, y: midY)
    }
    
    func calculateRadianBetween(point1: CGPoint, and point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let radian = atan2(deltaY, deltaX)
        
        return radian
    }
    
    func convertTimeIntervalToSpeed(timeInterval: TimeInterval) -> CGFloat {
        let distance: CGFloat = 100.0 // 이동 거리 (예시)
        let speed = distance / CGFloat(timeInterval)
        return speed
    }
}

