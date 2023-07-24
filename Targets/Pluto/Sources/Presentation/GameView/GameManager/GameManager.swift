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
    
    var scene: SKScene?
    // MARK: Input
    @Published var touchesBegin: (Set<UITouch>, SKScene)
    @Published var touchesEnd: (Set<UITouch>, SKScene)
    @Published var contact: SKPhysicsContact
    
    // MARK: Output
    
    // MARK: Nodes
    var nodes: Nodes
    var backGround: BackGround
    var label = SKLabelNode()
    var percentLabel = SKLabelNode()
    var map: [ObstacleProtocol]
    
    // MARK: Node-Action Dictionary
    var nodeActionDictionary: [String : SKAction] = [:]
    
    // MARK: Timer
    let gameTimer = GameTimer(timeInterval: 0.02)
    let throatTimer = GameTimer(timeInterval: 1)
    
    // MARK: Delegate
    var delegate: ShowAlertDelegate? = nil
    
    // MARK: private
    @Published var throatGauge: Int = 100
    private var gameConstants: GameConstants
    
    // MARK: Temp
    var ObstacleIndex = 0
    var plentTime = 0
    private var isNodeMove = false
    var succesPercent: Int {
        Int(CGFloat(ObstacleIndex) / CGFloat(map.count) * 100)
    }
    
    
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
    
    func restartGame(scene: SKScene) {
        settingGame(scene: scene)
    }
    
    func settingGame(scene: SKScene) {
        scene.isUserInteractionEnabled = false
        self.scene = scene
        
        scene.addChilds(nodes.all)
        nodes.settingPlanets()
        nodes.positioning(size: scene.size)
        nodes.setEachPhisicalBody()
        nodes.setName()
        nodes.imageSetting()
        scene.addChild(label)
        percentLabel.position = CGPoint(x: scene.view!.bounds.width / 2, y: 200)
        scene.addChild(percentLabel)
        
        label.position = CGPoint(x: scene.view!.bounds.width / 2, y: scene.view!.bounds.height / 2)
        
        label.text = "\(throatGauge)"
        percentLabel.text = "\(0.0)%"
    }
    
    func startGame() {
        gameTimer.startTimer(completion: gameTimerAction)
    }
    
    func gameTimerAction(_ x: Double) {
        // backGroundLayers
        if x.truncatingRemainder(dividingBy: 1.0) == 0 {
            
            let index = Int(x) % 30
            
            let backgroundNodes = backGround.timeLayer[index]
            scene?.addChilds(backgroundNodes.map { $0 })
            
            for node in backgroundNodes {
                node.runAndRemove(SKAction.sequence([SKAction.fadeIn(withDuration: 1), SKAction.fadeOut(withDuration: 1)]).forever)
                node.runAndRemove(SKAction.moveTo(x: -100, duration: node.duration), withKey: "moveBackground")
            }
        }
        
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
                print("@LOG")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.percentLabel.text = "\(self.succesPercent)%"
                }
                if !isNodeMove {
                    isNodeMove = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.scene?.isUserInteractionEnabled = true
                        self.nodes.astronaut.startGame()
                    }
                }
            }
        }
        plentTime += 1
    }
        
    func binding() {
        
        $touchesBegin
            .sink { [weak self] (touches, scene) in
                
                guard let self = self else { return }
                scene.isPaused = false
                for touch in touches {
                    let location = touch.location(in: scene)
                    
                    if self.nodes.rightButton.contains(location) {
                        if throatGauge > 0 {
                            nodes.astronaut.startTurnCounterClockwise()
                            throatTimer.startTimer { _ in
                                self.throatGauge -= 10
                                self.throatGauge = max(self.throatGauge, 0)
                                self.label.text = "\(self.throatGauge)"
                            }
                        }
                    }
                    else if self.nodes.leftButton.contains(location){
                        if throatGauge > 0 {
                            nodes.astronaut.startTurnClockwise()
                            throatTimer.startTimer { _ in
                                self.throatGauge -= 10
                                self.throatGauge = max(self.throatGauge, 0)
                                self.label.text = "\(self.throatGauge)"
                            }
                        }
                    }
                    
                    if self.nodes.changeColorOne.contains(location) {
                        let newColor = nodes.astronaut.type.combine(.one)
                        if nodes.astronaut.status == .inOribt {
                            guard let newAstronuat = nodes.astronaut.orbitPlanet?.changedColor(to: newColor) else { return }
                            nodes.astronaut = newAstronuat
                            nodes.setAstronuat()
                            scene.addChild(nodes.astronaut)
                            throatTimer.resetTimer()
                            nodes.astronaut.startFoward()
                        }
                    }
                    if self.nodes.changeColorTwo.contains(location) {
                        let newColor = nodes.astronaut.type.combine(.two)
                        if nodes.astronaut.status == .inOribt {
                            guard let newAstronuat = nodes.astronaut.orbitPlanet?.changedColor(to: newColor) else { return }
                            nodes.astronaut = newAstronuat
                            nodes.setAstronuat()
                            throatTimer.resetTimer()
                            scene.addChild(nodes.astronaut)
                            
                            nodes.astronaut.startFoward()
                        }
                    }
                    if self.nodes.pauseButton.contains(location) {
                        scene.isPaused = true
                        gameTimer.stopTimer()
                        delegate?.showAlert(alertType: .tutorial(activate: [.changeGreen, .turnClockWise],
                                                                 bottomString: "FUCK YOU GUYs", topString: "fuck the shit"))
                        //delegate?.showAlert(alertType: .pause)
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
                        throatTimer.resetTimer()
                        nodes.astronaut.endTurnCounterClockwise()
                    }
                    else if self.nodes.leftButton.contains(location){
                        throatTimer.resetTimer()
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
                    self.scene?.isPaused = true
                    delegate?.showAlert(alertType: .fail)
                }
                else if (nodeA?.name == "astronaut" && nodeB?.name == "planet") || (nodeA?.name == "planet" && nodeB?.name == "astronaut") {
                    if nodeA?.name == "planet", let astronaut = nodeB as? AstronautNode, let planet = nodeA as? PlanetNode {
                        if planet.astronautColor == astronaut.type {

                            astronaut.orbitPlanet = planet
                            astronaut.status = .inOribt
                            throatTimer.resetTimer()
                            throatTimer.startTimer { _ in
                                self.throatGauge += 10
                                self.throatGauge = min(self.throatGauge, 100)
                                self.label.text = "\(self.throatGauge)"
                            }
                            planet.startRotation(at: contact.contactPoint, thatNodePoint: astronaut)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                astronaut.removeFromParent()
                            }
                        }
                        else if planet.id != astronaut.id {
                            self.scene?.isPaused = true
                            delegate?.showAlert(alertType: .fail)
                        }
                    }
                    else if let astronaut = nodeA as? AstronautNode, let planet = nodeB as? PlanetNode {
                        if planet.astronautColor == astronaut.type {
                            astronaut.orbitPlanet = planet
                            astronaut.status = .inOribt
                            throatTimer.resetTimer()
                            throatTimer.startTimer { _ in
                                self.throatGauge += 10
                                self.throatGauge = min(self.throatGauge, 100)
                                self.label.text = "\(self.throatGauge)"
                            }
                            planet.startRotation(at: contact.contactPoint, thatNodePoint: astronaut)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                astronaut.removeFromParent()
                            }
                        }
                        else if planet.id != astronaut.id {
                            self.scene?.isPaused = true
                            delegate?.showAlert(alertType: .fail)
                        }
                    }
                    
                }
            }
            .store(in: &bag)
        
        $throatGauge
            .sink { gauge in
                if gauge <= 0 {
                    self.nodes.astronaut.removeAllActions()
                    self.nodes.astronaut.startFoward()
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

        var astronaut = AstronautNode(color: .white, size: CGSize(width: 30, height: 30))
        let leftButton = SKSpriteNode(color: .white, size: CGSize(width: 85, height: 85))
        let rightButton = SKSpriteNode(color: .white, size: CGSize(width: 85, height: 85))
        let changeColorOne = SKSpriteNode(color: AstronautColor.one.color, size: CGSize(width: 85, height: 85))
        let changeColorTwo = SKSpriteNode(color: AstronautColor.two.color, size: CGSize(width: 85, height: 85))
        let leftWall = SKSpriteNode()
        let rightWall = SKSpriteNode()
        let topWall = SKSpriteNode()
        let bottomWall = SKSpriteNode()
        var planets: [TempPlanetNode] = []
        var pauseButton = SKSpriteNode(color: .white, size: CGSize(width: 37, height: 144))
        
        
        var all: [SKNode] {
            [astronaut, leftButton, rightButton, leftWall, rightWall, topWall, bottomWall, changeColorOne, changeColorTwo, pauseButton]
        }
        
        func imageSetting() {
            
            let texture2 = SKTexture(imageNamed: "CounterClockWiseButton")
            rightButton.texture = texture2
            rightButton.zRotation = CGFloat.pi
            
            let texture1 = SKTexture(imageNamed: "ClockWiseButton")
            leftButton.texture = texture1
            
            let pauseButtonTexture = SKTexture(imageNamed: "buttonPause")
            pauseButton.texture = pauseButtonTexture
            
            let redButtonTexture = SKTexture(imageNamed: "RedButton_blue")
            changeColorTwo.texture = redButtonTexture
            changeColorTwo.zRotation = CGFloat.pi
            
            let blueButtonTexture = SKTexture(imageNamed: "BlueButton_blue")
            changeColorOne.texture = blueButtonTexture
            
        }
        
        func settingPlanets() {
            
            var index = 0
            let circlePath = TempPlanetNode.createCirclePath(center: .zero, radius: 50)
            let squarePath = TempPlanetNode.createSquarePath()
            
            for _ in 0 ..< 10 {
                
                var path = CGPath(rect: .zero, transform: nil)
                
                if index % 2 == 0 {
                    path = squarePath
                }
                else if index % 2 == 1 {
                    path = circlePath
                }
                
                let planet = TempPlanetNode()
                planet.path = path //TempPlanetNode(path: path)
                planet.physicsBody = SKPhysicsBody(polygonFrom: path)
               
                planet.fillColor = planet.color.color
                planet.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(planet.frame.height)))))
                
               
                planet.strokeColor = .clear
                
                planet.name = "planet"
                
                planet.physicsBody?.categoryBitMask = 4
                
                planet.physicsBody?.contactTestBitMask = 1
                planet.physicsBody?.collisionBitMask = 0
                planets.append(planet)
                
                index += 1
            }
        }
        
        func positioning(size: CGSize) {
            
            astronaut.position = CGPoint(x: 70, y: size.height / 2)
            astronaut.zPosition = 1
            
            pauseButton.positionFromLeftMiddle(0, size.height / 2)
            pauseButton.zPosition = 2
            
            leftButton.positionFromLeftBottom(46, 69.5)
            changeColorOne.positionFromLeftBottom(259, 69.5)
            changeColorOne.zPosition = 2
            leftButton.zPosition = 2
        
            changeColorTwo.positionFromLeftBottom(46, 689.5)
            rightButton.positionFromLeftBottom(259, 689.5)
            rightButton.zPosition = 2
            changeColorTwo.zPosition = 2
            
            leftWall.size = CGSize(width: 1, height: size.height * 2)
            rightWall.size = CGSize(width: 1, height: size.height * 2)
            topWall.size = CGSize(width: size.width, height: 116)
            topWall.color = UIColor(red: 0, green: 46 / 255, blue: 254 / 255, alpha: 1)
            bottomWall.size = CGSize(width: size.width, height: 116)
            bottomWall.color = UIColor(red: 0, green: 46 / 255, blue: 254 / 255, alpha: 1)
            
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
        
        func removeAll() {
            [astronaut, leftButton, rightButton, leftWall, rightWall, topWall, bottomWall, changeColorOne, changeColorTwo, pauseButton]
                .forEach { node in
                    node.removeAllActions()
                    node.removeAllChildren()
                }
            planets.forEach { node in
                node.removeAllActions()
                node.removeAllChildren()
                
            }
        }
        
        func setAstronuat() {
            astronaut.name = "astronaut"
            astronaut.physicsBody = SKPhysicsBody(rectangleOf: astronaut.frame.size)
            astronaut.physicsBody?.categoryBitMask = 1
            astronaut.physicsBody?.contactTestBitMask = 4 | 2
            astronaut.physicsBody?.collisionBitMask = 2
        }
        
        func setEachPhisicalBody() {
            for node in [leftWall, rightWall, topWall, bottomWall, astronaut] {
                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
            }
            
            leftWall.physicsBody?.categoryBitMask = 2
            rightWall.physicsBody?.categoryBitMask = 2
            topWall.physicsBody?.categoryBitMask = 2
            bottomWall.physicsBody?.categoryBitMask = 2
            
            astronaut.physicsBody?.categoryBitMask = 1
            
            astronaut.physicsBody?.contactTestBitMask = 4 | 2
            
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
        
        var timeLayer: [[Node]] = Array(repeating: [], count: 31)
        
        init(constants: GameConstants) {
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = Node(
                    time: time,
                    duration: constants.backgroundFirstLayerDuration )
                
                node.color = .yellow
                node.size = CGSize(width: 15, height: 15)
                node.zPosition = -1
                
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = Node(time: time,
                                duration: constants.backgroundSecondLayerDuration)
                
                node.color = .yellow
                node.zPosition = -1
                node.size = CGSize(width: 10, height: 10)
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
            
            for _ in 0 ... 100 {
                let time = Int.random(in: 0 ... 30)
                let node = Node(time: time,
                                duration: constants.backgroundThirdLayerDuration)
                
                node.color = .yellow
                node.zPosition = -1
                node.size = CGSize(width: 5, height: 5)
                node.positionFromLeftBottom(400, CGFloat(Int.random(in: 170 ... (674 - Int(node.size.height)))))
                timeLayer[time].append(node)
            }
        }
    }
}

extension GameManager: PassRotationingAstronautPointDelegate {
    
    func passAstronautPoint(at point: CGPoint) {
        if point.x < 0 || point.x > scene!.size.width || point.y < 170 || point.y > 674 {
            scene?.isPaused = true
            delegate?.showAlert(alertType: .fail)
        }
    }
}
