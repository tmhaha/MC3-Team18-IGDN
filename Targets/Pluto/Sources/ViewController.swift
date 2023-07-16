//
//  ViewController.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    var scene: GameScene?

    override func loadView() {
        super.loadView()
        self.view = SKView()
        self.view.bounds = UIScreen.main.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScene()
    }

    func setupScene() {
        if let view = self.view as? SKView, scene == nil {
            
            let gameManager = GameManager()
            let scene = gameManager.generateScene(size: view.bounds.size)
            view.presentScene(scene)
            self.scene = scene
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
