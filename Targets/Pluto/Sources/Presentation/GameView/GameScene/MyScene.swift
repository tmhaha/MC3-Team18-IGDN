//
//  MyScene.swift
//  SpriteKitTest
//
//  Created by changgyo seo on 2023/07/06.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameManager: GameManager
    
    init(gameManager: GameManager, size: CGSize) {
        self.gameManager = gameManager
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
       
        view.isMultipleTouchEnabled = true
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        gameManager.startGame(scene: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.touchesBegin = (touches, self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.touchesEnd = (touches, self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("@LOG CRUSH")
        gameManager.contact = contact
    }
}
