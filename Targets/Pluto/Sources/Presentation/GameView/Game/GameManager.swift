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
    
    var scene: GameScene?
    // MARK: Input
    @Published var touchesBegin: (Set<UITouch>, SKScene)
    @Published var touchesEnd: (Set<UITouch>, SKScene)
    @Published var contact: SKPhysicsContact
    
    // MARK: Output
    
    // MARK: Nodes
    var nodes: Nodes
    var backGround: BackGround
    var map: [ObstacleProtocol]
    
    // MARK: Node-Action Dictionary
    var nodeActionDictionary: [String : SKAction] = [:]
    
    // MARK: Timer
    let backgroundTimer = GameTimer(timeInterval: 1.0)
    
    // MARK: Delegate
    var delegate: ShowAlertDelegate? = nil
    
    // MARK: private
    @Published var throatGauge: Int = 100
    
    var gameConstants: GameConstants
    
    // MARK: Temp
    var ObstacleIndex = 0
    var plentTime = 0
    private var isNodeMove = false
    
    init(constants: GameConstants, map: [ObstacleProtocol]) {
        
        self.touchesBegin = ([], SKScene())
        self.touchesEnd = ([], SKScene())
        self.contact = SKPhysicsContact()
        self.nodes = Nodes()
        self.backGround = BackGround(constants: constants)
        self.gameConstants = constants
        self.map = map
        
        self.map.sort { $0.point.x < $1.point.x }
        
        binding()
    }

    func settingForNewGame(scene: GameScene) {
        scene.isUserInteractionEnabled = false
        self.scene = scene
        
        scene.addChilds(nodes.all)
        nodes.positioningNSizing(size: scene.size)
        nodes.setEachPhisicalBody()
        nodes.setName()
        nodes.imageSetting()
        
        nodes.leftThroat.delegate = self
    }
    
    func startGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.scene?.isUserInteractionEnabled = true
            self.nodes.astronaut.startGame()
        }
        map.sort(by: { $0.point.x < $1.point.x })
        
        var lastPosition = CGPoint()
        let moveAction = SKAction.moveBy(x: -32.5, y: 0, duration: 1)
        for item in map {
            let currentData = item
            let planet = currentData.makePlanetNode()
            planet.delegate = self
            scene?.addChild(planet)
            planet.startDirectionNodesRotation()
            
            let runPassPosition = SKAction.run {
                if planet.position.x <= 400 && !planet.isInScreen {
                    self.ObstacleIndex += 1
                    planet.isInScreen = true
                    let percent = CGFloat(self.ObstacleIndex) / CGFloat(self.map.count)
                    self.nodes.topProgressBar.percent = percent
                    self.nodes.bottomProgressBar.percent = percent
                    if !planet.tutorials.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.delegate?.showTutorial(tutorials: planet.tutorials)
                        }
                    }
                }
                if planet.position.x <= -100 {
                    planet.removeAllActions()
                    planet.removeFromParent()
                }
            }
            let sequence = SKAction.sequence([moveAction, runPassPosition]).forever
            planet.run(sequence)
            lastPosition = planet.position
        }
        
        let lastPlanet = SKSpriteNode(color: .brown.opacity(0.3), size: CGSize(width: 800, height: 800))
        lastPlanet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 800, height: 800))
        lastPlanet.position = CGPoint(x: lastPosition.x + 600, y: 422)
        lastPlanet.physicsBody?.categoryBitMask = 8
        lastPlanet.physicsBody?.contactTestBitMask = 1
        lastPlanet.physicsBody?.collisionBitMask = 0
        lastPlanet.name = "lastPlanet"
        lastPlanet.zPosition = -1
        
        scene?.addChild(lastPlanet)
        lastPlanet.run(moveAction.forever)
        
        backgroundTimer.startTimer(completion: backgroundTimerAction)
    }
    
    func binding() {
        
        $touchesBegin
            .sink { [weak self] (touches, scene) in
                print("@DEBUG hahah")
                guard let self = self else { return }
                
                for touch in touches {
                    let location = touch.location(in: scene)
                    
                    if self.nodes.rightButton.contains(location) {
                        print("@DEBUG hahah")
                        if throatGauge > 0 && nodes.astronaut.status != .inOribt {
                            nodes.astronaut.startTurnCounterClockwise()
                            useGague()
                        }
                    }
                    else if self.nodes.leftButton.contains(location){
                        print("@DEBUG hahah")
                        if throatGauge > 0  && nodes.astronaut.status != .inOribt {
                            nodes.astronaut.startTurnClockwise()
                            useGague()
                        }
                    }
                    
                    if self.nodes.changeColorOne.contains(location) {
                        changeColor(color: .one)
                    }
                    if self.nodes.changeColorTwo.contains(location) {
                        changeColor(color: .two)
                    }
                    if self.nodes.pauseButton.contains(location) {
                        stopGame(for: .pause)
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
                        stopGague()
                        nodes.astronaut.endTurnCounterClockwise()
                    }
                    else if self.nodes.leftButton.contains(location){
                        stopGague()
                        nodes.astronaut.endTurnClockwise()
                    }
                }
            }
            .store(in: &bag)
        
        $contact
            .sink { [weak self] contact in
                
                guard let self = self else { return }
                
                let nodeA = contact.bodyA.node
                let nodeB = contact.bodyB.node
                
                // 충돌 처리 로직을 추가합니다.
                if (nodeA?.name == "astronaut" && nodeB?.name == "wall") || (nodeA?.name == "wall" && nodeB?.name == "astronaut") {
                    stopGame(for: .fail)
                }
                else if (nodeA?.name == "astronaut" && nodeB?.name == "planet") || (nodeA?.name == "planet" && nodeB?.name == "astronaut") {
                    if nodeA?.name == "planet", let astronaut = nodeB as? AstronautNode, let planet = nodeA as? PlanetNode {
                        if !astronautContact(astronaut: astronaut, planet: planet, contact: contact) {
                            stopGame(for: .fail)
                        }
                    }
                    else if let astronaut = nodeA as? AstronautNode, let planet = nodeB as? PlanetNode {
                        if !astronautContact(astronaut: astronaut, planet: planet, contact: contact) {
                            stopGame(for: .fail)
                        }
                    }
                }
                if (nodeA?.name == "astronaut" && nodeB?.name == "lastPlanet") || (nodeA?.name == "lastPlanet" && nodeB?.name == "astronaut") {
                    
                    scene?.isUserInteractionEnabled = false
                    let roatationAction = SKAction.rotate(byAngle: CGFloat.pi * 4, duration: 5).forever
                    let moveAction = SKAction.move(to: CGPoint(x: 195, y: 422),
                                                   duration: 18)
                    let checkFinish = SKAction.run {
                        self.delegate?.showAlert(alertType: .success)
                    }
                    let sequence = SKAction.sequence([moveAction, checkFinish])
                    nodes.astronaut.removeAllActions()
                    let group = SKAction.group([roatationAction, sequence])
                    
                    nodes.astronaut.run(group)
                    if nodeA?.name == "lastPlanet" {
                        if let lastPlanet = nodeA as? SKSpriteNode {
                            lastPlanet.removeAllActions()
                            let moveAction = SKAction.move(to: CGPoint(x: 195, y: 422),
                                                           duration: 9)
                            lastPlanet.run(moveAction)
                        }
                    }
                    else {
                        if let lastPlanet = nodeB as? SKSpriteNode {
                            lastPlanet.removeAllActions()
                            let moveAction = SKAction.move(to: CGPoint(x: 195, y: 422),
                                                           duration: 18)
                            lastPlanet.run(moveAction)
                        }
                    }
                }
            }
            .store(in: &bag)
        
        $throatGauge
            .sink { gague in
                if gague <= 0 {
                    self.stopGagueForce()
                    self.nodes.leftThroat.percent = .zero
                    self.nodes.rightThroat.percent = .zero
                }
            }
            .store(in: &bag)
    }
}

extension GameManager {
    
    func generateScene(size: CGSize) ->  GameScene {
        GameScene(gameManager: self, size: size)
    }
    
    class Nodes {
        
        let background = SKSpriteNode()
        var astronaut = AstronautNode(color: .white, size: CGSize(width: 30, height: 30))
        let leftButton = SKSpriteNode(color: .white, size: CGSize(width: 85, height: 85))
        let leftThroat = ThroatProgressNode()
        let topProgressBar = ProgressBarNode()
        let bottomProgressBar = ProgressBarNode()
        let rightButton = SKSpriteNode(color: .white, size: CGSize(width: 85, height: 85))
        let rightThroat = ThroatProgressNode()
        let changeColorOne = SKSpriteNode(color: AstronautColor.one.color, size: CGSize(width: 85, height: 85))
        let changeColorTwo = SKSpriteNode(color: AstronautColor.two.color, size: CGSize(width: 85, height: 85))
        let leftWall = SKSpriteNode()
        let rightWall = SKSpriteNode()
        let topWall = SKSpriteNode()
        let bottomWall = SKSpriteNode()
        var pauseButton = SKSpriteNode(color: .white, size: CGSize(width: 37, height: 144))
        
        var all: [SKNode] {
            [background, bottomProgressBar, topProgressBar, leftThroat, rightThroat, astronaut, leftButton, rightButton, leftWall, rightWall, topWall, bottomWall, changeColorOne, changeColorTwo, pauseButton]
        }
        
        func imageSetting() {
            
            let texture2 = SKTexture(imageNamed: "CounterClockWiseButton")
            rightButton.texture = texture2
            rightButton.zRotation = CGFloat.pi
            
            let texture1 = SKTexture(imageNamed: "ClockWiseButton")
            leftButton.texture = texture1
            
            let pauseButtonTexture = SKTexture(imageNamed: "buttonPause")
            pauseButton.texture = pauseButtonTexture
            
            let redButtonTexture = SKTexture(imageNamed: "RedButton")
            changeColorTwo.texture = redButtonTexture
            changeColorTwo.zRotation = CGFloat.pi
            
            let blueButtonTexture = SKTexture(imageNamed: "GreenButton")
            changeColorOne.texture = blueButtonTexture
            
            let astronautTexture = SKTexture(imageNamed: AstronautColor.none.imageName)
            astronaut.texture = astronautTexture
            
            let bgTexture = SKTexture(imageNamed: "BackGround")
            background.texture = bgTexture
            
            let texture = SKTexture(imageNamed: "ButtonArea")
            bottomWall.texture = texture
            topWall.texture = texture
        }
        
        func positioningNSizing(size: CGSize) {
            
            background.position = CGPoint(x: size.width / 2, y: size.height / 2)
            background.size = size
            background.zPosition = -100
            
            topProgressBar.zPosition = 3
            bottomProgressBar.zPosition = 3
            astronaut.position = CGPoint(x: 70, y: size.height / 2)
            astronaut.zPosition = 1
            
            pauseButton.positionFromLeftMiddle(0, size.height / 2)
            pauseButton.zPosition = 100
            
            leftButton.positionFromLeftBottom(46, 69.5)
            leftThroat.position = leftButton.position
            bottomProgressBar.position = CGPoint(x: 320, y: 192.5)
            
            changeColorOne.positionFromLeftBottom(259, 69.5)
            changeColorOne.zPosition = 100
            leftButton.zPosition = 100
            leftThroat.zPosition = 100
            
            changeColorTwo.positionFromLeftBottom(46, 689.5)
            rightButton.positionFromLeftBottom(259, 689.5)
            topProgressBar.position = CGPoint(x: 320, y: 651.5)
            topProgressBar.zRotation = CGFloat.pi
            rightThroat.position = rightButton.position
            rightThroat.zRotation = CGFloat.pi
            rightThroat.zPosition = 100
            rightButton.zPosition = 100
            changeColorTwo.zPosition = 100
            
            leftWall.size = CGSize(width: 1, height: size.height * 2)
            rightWall.size = CGSize(width: 1, height: size.height * 2)
            topWall.size = CGSize(width: size.width, height: 116)
            topWall.zRotation = CGFloat.pi
            bottomWall.size = CGSize(width: size.width, height: 116)
            
            leftWall.position = CGPoint(x: 0, y: 0)
            rightWall.position = CGPoint(x: size.width - 1 , y: 0)
            topWall.positionFromLeftBottom(0, size.height - 170)
            bottomWall.positionFromLeftBottom(0, 54)
        }
        
        func setName() {
            astronaut.name = "astronaut"
            leftWall.name = "wall"
            rightWall.name = "wall"
            topWall.name = "wall"
            bottomWall.name = "wall"
        }
        
        func setAstronuat() {
            astronaut.name = "astronaut"
            astronaut.physicsBody?.categoryBitMask = 1
            astronaut.physicsBody?.contactTestBitMask = 4 | 2
            astronaut.physicsBody?.collisionBitMask = 2
        }
        
        func setEachPhisicalBody() {
            for node in [leftWall, rightWall, topWall, bottomWall] {
                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
            }
            
            let astronautPath = UIBezierPath()
            
            astronautPath.move(to: CGPoint(x: -7.49, y: 0))
            astronautPath.addLine(to: CGPoint(x: -9.49, y: 7.12))
            astronautPath.addLine(to: CGPoint(x: 8.41, y: 0))
            astronautPath.addLine(to: CGPoint(x: -9.49, y: -7.12))
            
            astronautPath.close()
            
            astronaut.physicsBody = SKPhysicsBody(polygonFrom: astronautPath.cgPath)
            
            leftWall.physicsBody?.categoryBitMask = 2
            rightWall.physicsBody?.categoryBitMask = 2
            topWall.physicsBody?.categoryBitMask = 2
            bottomWall.physicsBody?.categoryBitMask = 2
            
            astronaut.physicsBody?.categoryBitMask = 1
            
            astronaut.physicsBody?.contactTestBitMask = 4 | 2 | 8
            
            leftWall.physicsBody?.contactTestBitMask = 1
            leftWall.physicsBody?.collisionBitMask = 1
            
            rightWall.physicsBody?.contactTestBitMask = 1
            rightWall.physicsBody?.collisionBitMask = 1
            
            topWall.physicsBody?.contactTestBitMask = 1
            topWall.physicsBody?.collisionBitMask = 1
            
            bottomWall.physicsBody?.contactTestBitMask = 1
            bottomWall.physicsBody?.collisionBitMask = 1
            
            astronaut.physicsBody?.collisionBitMask = 2
        }
    }
}

extension GameManager {
    
    class BackGround {
        
        class Node: SKSpriteNode {
            
            let id: String = UUID().uuidString
            var time: Int = 0
            var duration: TimeInterval = 0.0
            
            override init(texture: SKTexture? = nil, color: UIColor, size: CGSize) {
                super.init(texture: nil, color: color, size: size)
            }
            
            convenience init(time: Int, duration: TimeInterval) {
                self.init(color: .clear, size: .zero)
                
                self.time = time
                self.duration = duration
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        var timeLayer: [[Node]] = Array(repeating: [], count: 301)
        
        init(constants: GameConstants) {
            
            for _ in 0 ... 200 {
                let time = Int.random(in: 0 ... 300)
                let node = Node(
                    time: time,
                    duration: constants.backgroundFirstLayerDuration )
                
                let sizeNTexture = makeLayer1Random()
                node.texture = sizeNTexture.0
                node.size = sizeNTexture.1
                node.zPosition = -1
                
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 1000 {
                let time = Int.random(in: 0 ... 300)
                let node = Node(time: time,
                                duration: constants.backgroundSecondLayerDuration)
                
                node.zPosition = -1
                let sizeNTexture = makeLayer2Random()
                node.texture = sizeNTexture.0
                node.size = sizeNTexture.1
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 2000 {
                let time = Int.random(in: 0 ... 300)
                let node = Node(time: time,
                                duration: constants.backgroundThirdLayerDuration)
                
                node.zPosition = -1
                let sizeNTexture = makeLayer3Random()
                node.texture = sizeNTexture.0
                node.size = sizeNTexture.1
                
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
        }
        
        func makeLayer3Random() -> (SKTexture, CGSize) {
            let first = Int.random(in: 11 ... 13)
            let second = Int.random(in: 1 ... 20)
            let result = "\(first)-\(second)"
            var bgSize = CGSize()
            
            switch second % 4 {
            case 1:
                bgSize = CGSize(width: 2, height: 2)
            case 2:
                bgSize = CGSize(width: 3, height: 3)
            case 3:
                bgSize = CGSize(width: 4, height: 4)
            case 0:
                bgSize = CGSize(width: 5, height: 5)
            default:
                break
            }
            
            return (SKTexture(imageNamed: result), bgSize)
        }
        
        func makeLayer2Random() -> (SKTexture, CGSize) {
            let first = Int.random(in: 1...9)
            var size = CGSize()
            
            
            switch first % 3 {
            case 1:
                size = CGSize(width: 10, height: 10)
            case 2:
                size = CGSize(width: 8, height: 8)
            case 0:
                size = CGSize(width: 6, height: 6)
            default:
                break
            }
            
            return (SKTexture(imageNamed: "21-\(first)"), size)
        }
        
        func makeLayer1Random() -> (SKTexture, CGSize) {
            let first = Int.random(in: 1...3)
            let second = Int.random(in: 1...4)
            
            var size = CGSize()
            
            switch second % 4 {
            case 1:
                size = CGSize(width: 40, height: 1)
            case 2:
                size = CGSize(width: 50, height: 2)
            case 3:
                size = CGSize(width: 60, height: 4)
            case 0:
                size = CGSize(width: 70, height: 8)
            default:
                break
            }
            return (SKTexture(imageNamed: "3\(first)-\(second)"), size)
        }
    }
}
