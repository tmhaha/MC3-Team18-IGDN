//
//  MyScene.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/06.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameManager: GameManager
    var isRealPause = false
    var firstTouch = false
    override var isPaused: Bool {
        didSet(newValue) {
            if isRealPause && !firstTouch {
                firstTouch = true
                isPaused = true
            }
        }
    }
    
    init(gameManager: GameManager, size: CGSize) {
        self.gameManager = gameManager
        super.init(size: size)
        self.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        gameManager.settingForNewGame(scene: self)
        gameManager.startGame()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.touchesBegin = (touches, self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.touchesEnd = (touches, self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameManager.contact = contact
    }
    
    @objc func appDidEnterBackground() {
        gameManager.stopGame(for: .pause)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
