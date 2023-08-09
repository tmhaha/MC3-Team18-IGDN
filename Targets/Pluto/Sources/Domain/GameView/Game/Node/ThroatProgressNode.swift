//
//  ThroatProgressNode.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/25.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

class ThroatProgressNode: SKShapeNode {
    
    var percent: CGFloat = 1.0 {
        didSet(newValue) {
            if newValue > .zero {
                delegate?.send(gague: newValue)
            }
        }
    }
    var delegate: SendThroatGaugeDelegate? = nil
    var radius: CGFloat = 48
    var recenteAngle = (CGFloat.pi * 2 + (CGFloat.pi / 2))
    var currentAngle: CGFloat = 0.0
    var animationDuration: TimeInterval = 5
    
    override init() {
        super.init()
        createFanShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createFanShape() {
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: -CGFloat.pi / 4, endAngle: -CGFloat.pi / 4 + CGFloat.pi * 2, clockwise: true)
        path.close()
        
        self.path = path.cgPath
        self.strokeColor = SettingData.shared.selectedTheme.mainLight.uiColor
        self.lineWidth = 2
    }
    
    func stopUse() {
        if percent > 1 {
            self.recenteAngle = self.currentAngle
        }
        removeAllActions()
    }
    
    func useThroat() {
        
        let startAngle: CGFloat = (CGFloat.pi / 2)//(CGFloat.pi * 2 + (CGFloat.pi / 2))
        let initPercent = percent
        
        let customAction = SKAction.customAction(withDuration: self.animationDuration) { [weak self] (node, time) in
            
            guard let self = self else { return }
            if self.currentAngle >= 0 {
                let t = initPercent - (CGFloat(time) / self.animationDuration)
                self.percent = t
                self.currentAngle = startAngle + (CGFloat.pi * 2 * t)
                let fanPath = UIBezierPath()
                fanPath.addArc(withCenter: .zero, radius: radius, startAngle: startAngle, endAngle: currentAngle, clockwise: true)
                self.path = fanPath.cgPath
            }
            else{
                stopUse()
            }
        }
        
        run(customAction)
    }
    
    func fillThroat() {
      
        let startAngle: CGFloat = CGFloat.pi / 2
        let initPercent = percent
        let customAction = SKAction.customAction(withDuration: self.animationDuration) { [weak self] (node, time) in
            guard let self = self else { return }
            if currentAngle <= (CGFloat.pi * 2 + (CGFloat.pi / 2)) {
                let t =  initPercent + (CGFloat(time) / self.animationDuration)
                self.percent = t
                self.currentAngle = startAngle + (CGFloat.pi * 2 * t)
                let fanPath = UIBezierPath()
                fanPath.addArc(withCenter: .zero, radius: radius, startAngle: startAngle, endAngle: currentAngle, clockwise: true)
                self.path = fanPath.cgPath
            }
            else {
                stopUse()
            }
        }
        
        run(customAction)
    }
}
