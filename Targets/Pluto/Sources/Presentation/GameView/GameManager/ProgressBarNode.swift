//
//  ProgressBarNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/26.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class ProgressBarNode: SKShapeNode {
    
    let totalWidth = 298.0
    var percent: CGFloat = 0.0 {
        willSet(newValue) {
            changeProgress(newValue * totalWidth)
            let text = newValue * 100
            label.text = "\(Int(text))%"
        }
    }
    var directionNode = SKShapeNode()
    var label = SKLabelNode()
    var progress = SKSpriteNode()
    
    override init() {
        super.init()
        
        let backgroundNode = SKShapeNode(rectOf: CGSize(width: totalWidth, height: 6), cornerRadius: 3)
        backgroundNode.strokeColor = .clear
        backgroundNode.fillColor = UIColor(red: 180 / 255, green: 193 / 255, blue: 1, alpha: 1)
        addChild(backgroundNode)

        let roundedRectTexture = createRoundedRectTexture(size: CGSize(width: 0, height: 6),
                                                          cornerRadius: 20,
                                                          fillColor: UIColor(red: 0, green: 46 / 255, blue: 254 / 255, alpha: 1))
        progress = SKSpriteNode(texture: roundedRectTexture)
        progress.positionFromLeftMiddle(-CGFloat(totalWidth)/2, 0)
        progress.color = UIColor(red: 0, green: 46 / 255, blue: 254 / 255, alpha: 1)
        
        addChild(progress)

        let path = UIBezierPath()

        path.move(to: CGPoint(x: 0, y: -8)) // 시작점 (100, 100)
        path.addLine(to: CGPoint(x: 8, y: 8)) // 두 번째 점 (150, 150)
        path.addLine(to: CGPoint(x: -8, y: 8)) // 세 번째 점 (50, 150)
        path.close() // 삼각형

        directionNode.path = path.cgPath
        directionNode.fillColor = .blue
        directionNode.strokeColor = .clear

        label.text = "0%"
        label.fontSize = 25
        label.position = CGPoint(x: 0, y: 14)

        directionNode.position = CGPoint(x: -totalWidth / 2, y: 18)
        directionNode.addChild(label)
        addChild(directionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeProgress(_ dx: CGFloat) {
        let duration = (dx / totalWidth) * 3
        let currentPrograssLength = progress.size.width
        directionNode.run(SKAction.move(by: CGVector(dx: dx, dy: 0), duration: duration))
        let customAction = SKAction.customAction(withDuration: duration) { nodes, time in
            
            let currentlength = currentPrograssLength + (dx * (time / duration))
            let roundedRectTexture = self.createRoundedRectTexture(size: CGSize(width: currentlength, height: 6),
                                                              cornerRadius: 3,
                                                              fillColor: UIColor(red: 0, green: 46 / 255, blue: 254 / 255, alpha: 1))
            self.progress = SKSpriteNode(texture: roundedRectTexture)
            self.addChild(self.progress)
            self.progress.positionFromLeftMiddle(-CGFloat(self.totalWidth) / 2.0, 0)
        }
        
        progress.run(customAction)
    }
    
    func createRoundedRectTexture(size: CGSize, cornerRadius: CGFloat, fillColor: UIColor) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let roundedRectPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
            fillColor.setFill()
            roundedRectPath.fill()
        }
        
        return SKTexture(image: image)
    }
    
}
