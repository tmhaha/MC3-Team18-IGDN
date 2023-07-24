//
//  SKScene+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import SpriteKit

extension SKScene {
    func addChilds(_ childs: [SKNode]) {
        for child in childs {
            addChild(child)
        }
    }
}
