//
//  Object.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/22.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

struct Object: ObstacleProtocol {
    var point: CGPoint
    var size: CGSize
    var color: AstronautColor
    var path: CGPath
    var imageName: String
    var isClockWise: Bool
    
    // 초기화
    init(creativeObject: CreativeObject) {
        self.point = creativeObject.point
        if creativeObject.shapeIndex == 3 {
            self.size = CreativeObject.CGSizeList_Diamond[creativeObject.sizeIndex]
        }
        else {
            self.size = CreativeObject.CGSizeList[creativeObject.sizeIndex]
        }
        self.path = creativeObject.path
        self.imageName = Obstacle.image[creativeObject.colorIndex][creativeObject.sizeIndex][creativeObject.shapeIndex]
        self.isClockWise = Obstacle.isClockWise[creativeObject.shapeIndex]
        
        switch creativeObject.color {
        case "creative_color_white":
            self.color = .none
        case "creative_color_red":
            self.color = .two
        case "creative_color_yellow":
            self.color = .combine
        case "creative_color_green":
            self.color = .one
        default:
            self.color = .none
        }
    }
}

// MARK: 사용예시
//var objects: [Object] = []
//for object in viewModel.objectList {
//    let transferingObject= Object(creativeObject: object)
//    objects.append(transferingObject)
//}
