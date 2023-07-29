//
//  ProgressBarNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/26.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class ProgressBarNode: SKShapeNode {
    
    let totalWidth = 100.0
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

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: -4, y: -8))
        path.addLine(to: CGPoint(x: 12, y: 0)) //
        path.addLine(to: CGPoint(x: -4, y: 8)) //
        path.close() // 삼각형

        directionNode.path = path.cgPath
        directionNode.fillColor = .white
        directionNode.strokeColor = .clear
        directionNode.zPosition = 3

        label.text = "0%"
        label.fontSize = 16
        label.position = CGPoint(x: (totalWidth / 2) - (label.frame.width / 2), y: 6)
        
        directionNode.position = CGPoint(x: -totalWidth / 2, y: 0)
        addChild(label)
        addChild(directionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeProgress(_ targetLength: CGFloat) {
        directionNode.removeAllActions()
        progress.removeAllActions()
        let duration = (targetLength / totalWidth) * 3
        let currentPrograssLength = progress.size.width
        directionNode.run(SKAction.move(by: CGVector(dx: targetLength - currentPrograssLength, dy: 0), duration: duration))
        let customAction = SKAction.customAction(withDuration: duration) { nodes, time in
            
            let currentlength = currentPrograssLength + ((targetLength - currentPrograssLength) * (time / duration))
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
