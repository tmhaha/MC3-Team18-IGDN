//
//  GameManager.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/09.
//

import SpriteKit
import Combine

class GameManager: ObservableObject {
    
    // MARK: CancellableBag
    var bag = Set<AnyCancellable>()
    
    // MARK: Input
    @Published var touchesBegin: (Set<UITouch>, SKScene)
    @Published var touchesEnd: (Set<UITouch>, SKScene)
    @Published var contact: SKPhysicsContact
    
    
    // MARK: Output
    
    // MARK: Nodes
    var nodes = Nodes()
    var backGround = BackGround()
    
    // MARK: Timer
    let gameTimer = GameTimer()
    
    
    init() {
        self.touchesBegin = ([], SKScene())
        self.touchesEnd = ([], SKScene())
        self.contact = SKPhysicsContact()
        
        binding()
    }
    
    func startGame(scene: SKScene) {
        
        for nodes in backGround.timeLayer {
            scene.addChilds(nodes.map { $0.node })
        }
        scene.addChilds(nodes.all)
        
        nodes.astronaut.startGame()
        nodes.positioning(size: scene.size)
        nodes.setEachPhisicalBody()
        nodes.setName()
        gameTimer.startTimer(completion: timerAction)
    }
    
    func timerAction(_ x: Int) {
        let nodes = backGround.timeLayer[x]
        
        for node in nodes {
            node.node.run( SKAction.moveTo(x: -100, duration: node.duration))
        }
    }
    
    func binding() {
        
        $touchesBegin
            .sink { [weak self] (touches, scene) in
                
                guard let self = self else { return }
                
                for touch in touches {
                    let location = touch.location(in: scene)
                    
                    if self.nodes.rightButton.contains(location) {
                        nodes.astronaut.StartTurnCounterClockwise()
                    }
                    if self.nodes.leftButton.contains(location){
                        nodes.astronaut.startTurnClockwise()
                    }
                    if self.nodes.changeColorOne.contains(location) {
                        nodes.astronaut.astronautColor.combine(.one)
                    }
                    if self.nodes.changeColorTwo.contains(location) {
                        nodes.astronaut.astronautColor.combine(.two)
                    }
                }
            }
            .store(in: &bag)
        
        $touchesEnd
            .sink {  [weak self] (touches, scene) in
                
                guard let self = self else { return }
                
                for touch in touches {
                    let location = touch.location(in: scene)
                    
                    if self.nodes.rightButton.contains(location) {
                        nodes.astronaut.endTurnCounterClockwise()
                    }
                    if self.nodes.leftButton.contains(location){
                        nodes.astronaut.endTurnClockwise()
                    }
                }
            }
            .store(in: &bag)
        
        $contact
            .sink { [weak self] contact in
                
                guard let self = self else { return }
                
                let nodeA = contact.bodyA.node as? SKSpriteNode
                let nodeB = contact.bodyB.node as? SKSpriteNode
                
                // 충돌 처리 로직을 추가합니다.
                if (nodeA?.name == "astronaut" && nodeB?.name == "wall") || (nodeA?.name == "wall" && nodeB?.name == "astronaut") {
                    self.nodes.astronaut.removeAllActions()
                }
            }
            .store(in: &bag)
    }
}

extension GameManager {
    
    func generateScene(size: CGSize) ->  GameScene {
        GameScene(gameManager: self, size: size)
    }
    
    struct Nodes {
        
        let astronaut = AstronautNode(color: .red, size: CGSize(width: 30, height: 30))
        let leftButton = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
        let rightButton = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
        let changeColorOne = SKSpriteNode(color: AstronautColor.one.color, size: CGSize(width: 50, height: 50))
        let changeColorTwo = SKSpriteNode(color: AstronautColor.two.color, size: CGSize(width: 50, height: 50))
        let leftWall = SKSpriteNode()
        let rightWall = SKSpriteNode()
        let topWall = SKSpriteNode()
        let bottomWall = SKSpriteNode()
        
        var all: [SKNode] {
            [astronaut, leftButton, rightButton, leftWall, rightWall, topWall, bottomWall, changeColorOne, changeColorTwo]
        }
        
        func positioning(size: CGSize) {
            
            astronaut.position = CGPoint(x: size.width / 2, y: size.height / 2)
            leftButton.position = CGPoint(x: size.width / 2 - 50, y: 50)
            rightButton.position = CGPoint(x: size.width / 2 + 50, y: 50)
            
            changeColorOne.position = CGPoint(x: size.width / 2 - 50, y: 150)
            changeColorTwo.position = CGPoint(x: size.width / 2 + 50, y: 150)
            
            leftWall.size = CGSize(width: 1, height: size.height * 2)
            rightWall.size = CGSize(width: 1, height: size.height * 2)
            topWall.size = CGSize(width: size.width * 2, height: 1)
            bottomWall.size = CGSize(width: size.width * 2, height: 1)
            
            leftWall.position = CGPoint(x: 0, y: 0)
            rightWall.position = CGPoint(x: size.width - 1 , y: 0)
            topWall.position = CGPoint(x: 0, y: size.height - 1)
            bottomWall.position = CGPoint(x: 0, y: 0)
            
        }
        
        func setName() {
            astronaut.name = "astronaut"
            leftWall.name = "wall"
            rightWall.name = "wall"
            topWall.name = "wall"
            bottomWall.name = "wall"
        }
        
        func setEachPhisicalBody() {
            for node in [astronaut, leftWall, rightWall, topWall, bottomWall] {
                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
            }
            
            astronaut.physicsBody?.contactTestBitMask = 0x2
            astronaut.physicsBody?.categoryBitMask = 0x1
            astronaut.physicsBody?.collisionBitMask = 0x0
            
            
            leftWall.physicsBody?.contactTestBitMask = 0x1
            leftWall.physicsBody?.categoryBitMask = 0x2
            leftWall.physicsBody?.collisionBitMask = 0x0
            
            rightWall.physicsBody?.contactTestBitMask = 0x1
            rightWall.physicsBody?.categoryBitMask = 0x2
            rightWall.physicsBody?.collisionBitMask = 0x0
            
            topWall.physicsBody?.contactTestBitMask = 0x1
            topWall.physicsBody?.categoryBitMask = 0x2
            topWall.physicsBody?.collisionBitMask = 0x0
            
            bottomWall.physicsBody?.contactTestBitMask = 0x1
            bottomWall.physicsBody?.categoryBitMask = 0x2
            bottomWall.physicsBody?.collisionBitMask = 0x0
        }
    }
}

extension GameManager {
    
    class BackGround {
        
        struct BackGroundNode {
            
            let node: SKSpriteNode
            let time: Int
            let duration: TimeInterval
        }
        
        var timeLayer: [[BackGroundNode]] = Array(repeating: [], count: 31)
        
        
        init() {
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = BackGroundNode(node: SKSpriteNode(color: .yellow,
                                                             size: CGSize(width: 15, height: 15)),
                                          time: time,
                                          duration: 5 )
                
                node.node.position = CGPoint(x: 400, y: CGFloat(Int.random(in: 0 ... 800)))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = BackGroundNode(node: SKSpriteNode(color: .yellow,
                                                             size: CGSize(width: 10, height: 10)),
                                          time: time,
                                          duration: 10)
                
                node.node.position = CGPoint(x: 400, y: CGFloat(Int.random(in: 0 ... 800)))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = BackGroundNode(node: SKSpriteNode(color: .yellow,
                                                             size: CGSize(width: 5, height: 5)),
                                          time: time,
                                          duration: 20)
                
                node.node.position = CGPoint(x: 400, y: CGFloat(Int.random(in: 0 ... 800)))
                timeLayer[time].append(node)
            }
        }
    }
}

extension GameManager {
    
    
}
