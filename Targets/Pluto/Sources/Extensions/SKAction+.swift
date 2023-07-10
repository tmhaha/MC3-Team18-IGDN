//
//  SKAction.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

extension SKAction {
    
    var forever: SKAction {
        SKAction.repeatForever(self)
    }
    
    func debug( _ completion: @escaping ()-> ()) -> SKAction {
        let run = SKAction.run { completion() }
        return SKAction.sequence([self, run])
    }
}
