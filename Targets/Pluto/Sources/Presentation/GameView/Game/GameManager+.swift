//
//  GameManager+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/29.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit


// MARK: - 궤도를 돌고 있는 상태에서 나갔을 때를 인지하기 위해 있는 Delegate
extension GameManager: PassRotationingAstronautPointDelegate {
    
    func passAstronautPoint(at point: CGPoint) {
        if point.x < 0 || point.x > 400 || point.y < 170 || point.y > 674 {
            stopGame(for: .fail)
        }
    }
}

// MARK: - 현재 진행도를 받아서 ThroatGague를 게임에서 영향을 받게하기 위해 있는 Delegate
extension GameManager: SendThroatGaugeDelegate {
    func send(gague: CGFloat) {
        let temp = gague * 100
        
        self.throatGauge = Int(temp)
    }
}

// MARK: - 기본적인 game들의 함수
extension GameManager {
    
    // 주인공과 행성이 닿았을 때 부르는 함수 -> 정상적인 부딪힘인지 리턴한다.
    func astronautContact(astronaut: AstronautNode, planet: PlanetNode, contact: SKPhysicsContact) -> Bool {
        if planet.astronautColor == astronaut.type {
            
            // 주인공이 현재 돌고 있는 행성을 가진다
            astronaut.orbitPlanet = planet
            astronaut.status = .inOribt
            nodes.leftThroat.fillThroat()
            nodes.rightThroat.fillThroat()
            planet.startRotation(at: contact.contactPoint, thatNodePoint: astronaut)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                astronaut.removeFromParent()
            }
            return true
        }
        else if planet.id == astronaut.id {
            return true
        }
        return false
    }
    
    // 게임을 멈춤
    func stopGame(for alert: GameAlertType) {
        self.scene?.isPaused = true
        self.scene?.isRealPause = true
        backgroundTimer.stopTimer()
        delegate?.showAlert(alertType: alert)
    }
    
    // 게임 리스타트
    func restartGame() {
        self.scene?.isRealPause = false
        self.scene?.firstTouch = false
        self.scene?.isPaused = false
        self.scene?.isHidden = false
        backgroundTimer.restartTimer()
        scene?.isUserInteractionEnabled = true
    }
    // 게임 종료
    func finishGame() {
        backgroundTimer.resetTimer()
        scene = nil
        
    }
    
    // 색변경
    func changeColor(color: AstronautColor) {
        
        let newColor = nodes.astronaut.type.combine(color)
        typeForChangeColor(newColor)
        if nodes.astronaut.status == .inOribt {
            guard let newAstronuat = nodes.astronaut.orbitPlanet?.changedColor(to: newColor) else { return }
            nodes.astronaut = newAstronuat
            nodes.setAstronuat()
            nodes.leftThroat.stopUse()
            nodes.rightThroat.stopUse()
            scene?.addChild(nodes.astronaut)
            
            nodes.astronaut.startFoward()
        }
    }
    
    // 트로스트 사용
    func useGague() {
        nodes.leftThroat.useThroat()
        nodes.rightThroat.useThroat()
    }
    
    // 트로스트 그만
    func stopGague() {
        nodes.leftThroat.stopUse()
        nodes.rightThroat.stopUse()
    }
    
    // 트로스트 사용 중지
    func stopGagueForce() {
        self.nodes.leftThroat.stopUse()
        self.nodes.rightThroat.stopUse()
        self.nodes.astronaut.removeAllActions()
        self.nodes.astronaut.startFoward()
    }
    
    // 버튼의 눌림을 표시
    func typeForChangeColor(_ newType: AstronautColor) {
        let redButton = SKTexture(imageNamed: "RedButton")
        let greenButton = SKTexture(imageNamed: "GreenButton")
        let redButtonDisable = SKTexture(imageNamed: "RedButtonDisable")
        let greenButtonDisable = SKTexture(imageNamed: "GreenButtonDisable")
        switch newType {
        case .one:
            nodes.changeColorOne.texture = greenButtonDisable
            nodes.changeColorTwo.texture = redButton
        case .two:
            nodes.changeColorOne.texture = greenButton
            nodes.changeColorTwo.texture = redButtonDisable
        case .none:
            nodes.changeColorOne.texture = greenButton
            nodes.changeColorTwo.texture = redButton
        case .combine:
            nodes.changeColorOne.texture = greenButtonDisable
            nodes.changeColorTwo.texture = redButtonDisable
        }
    }
    
    // 추후를 위해 남겨둠
//    func infinitePlanet() {
//
//        var index = 0
//        let circlePath = TempPlanetNode.createCirclePath(center: .zero, radius: 50)
//        let squarePath = TempPlanetNode.createSquarePath()
//
//        for _ in 0 ..< 10 {
//
//            var path = CGPath(rect: .zero, transform: nil)
//
//            if index % 2 == 0 {
//                path = squarePath
//            }
//            else if index % 2 == 1 {
//                path = circlePath
//            }
//
//            let planet = TempPlanetNode()
//            planet.path = path //TempPlanetNode(path: path)
//            planet.physicsBody = SKPhysicsBody(polygonFrom: path)
//
//            planet.fillColor = planet.color.color
//            planet.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(planet.frame.height)))))
//
//            planet.strokeColor = .clear
//
//            planet.name = "planet"
//
//            planet.physicsBody?.categoryBitMask = 4
//
//            planet.physicsBody?.contactTestBitMask = 1
//            planet.physicsBody?.collisionBitMask = 0
//            planets.append(planet)
//
//            index += 1
//        }
//    }
}
