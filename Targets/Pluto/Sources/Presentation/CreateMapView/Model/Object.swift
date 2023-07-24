//
//  Object.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/22.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

struct Object {
    var point: CGPoint
    var size: CGSize
    var color: UIColor
    var path: CGPath
    var imageName: String
    var isClockWise: Bool
    
    // 초기화
    init(creativeObject: CreativeObject) {
        self.point = creativeObject.point
        self.size = CreativeObject.CGSizeList[creativeObject.sizeIndex]
        self.color = UIColor(hex: 0x000000)/* 어떻게 매핑할지 결정해야 합니다. */
        self.path = creativeObject.path
        self.imageName = Obstacle.image[creativeObject.colorIndex][creativeObject.sizeIndex][creativeObject.shapeIndex]
        self.isClockWise = Obstacle.isClockWise[creativeObject.shapeIndex]
    }
}

// MARK: 사용예시
//var objects: [Object] = []
//for object in viewModel.objectList {
//    let transferingObject= Object(creativeObject: object)
//    objects.append(transferingObject)
//}
