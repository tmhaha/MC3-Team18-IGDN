//
//  CreativeObject.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/14.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

public struct CreativeObject: Equatable, Codable {
    enum ShapeType {
        case rectangle(cornerRadius: CGFloat)
        case diamond(cornerRadius: CGFloat)
        case triangle(cornerRadius: CGFloat)
        case circle
    }
    
    let point: CGPoint
    let color: String
    let size: String
    let shape: String
    let pathIndex: Int
    let rect: CGRect
    let colorIndex: Int
    let sizeIndex: Int
    let shapeIndex: Int
    var object: UIImageView {
        let view = UIImageView(frame: rect)
        view.backgroundColor = .clear
        view.image = UIImage(named: "\(Obstacle.image[colorIndex][sizeIndex][shapeIndex])")
        return view
    }

    var path: CGPath {
        return CreativeObject.pathList[pathIndex]
    }
    
    public init(point: CGPoint, color: String, size: String, shape: String, pathIndex: Int, rect: CGRect, colorIndex: Int, sizeIndex: Int, shapeIndex: Int) {
        self.point = point
        self.color = color
        self.size = size
        self.shape = shape
        self.pathIndex = pathIndex
        self.rect = rect
        self.colorIndex = colorIndex
        self.sizeIndex = sizeIndex
        self.shapeIndex = shapeIndex
    }
    
    public static func == (lhs: CreativeObject, rhs: CreativeObject) -> Bool {
        return lhs.point == rhs.point
    }
    
    static let CGSizeList: [CGSize] = [
        CGSize(width: 75.0, height: 75.0),
        CGSize(width: 105.0, height: 105.0),
        CGSize(width: 150.0, height: 150.0),
    ]
    
    static let CGSizeList_Diamond: [CGSize] = [
        CGSize(width: 62.79, height: 90.0),
        CGSize(width: 87.91, height: 126.0),
        CGSize(width: 125.58, height: 180.0),
    ]
    
    static var pathList: [CGPath] = [
        CreatePath.createPath(size: CreativeObject.CGSizeList[0], shapeType: .circle),
        CreatePath.createPath(size: CreativeObject.CGSizeList[1], shapeType: .circle),
        CreatePath.createPath(size: CreativeObject.CGSizeList[2], shapeType: .circle),
        CreatePath.createPath(size: CreativeObject.CGSizeList[0], shapeType: .rectangle(cornerRadius: 23)),
        CreatePath.createPath(size: CreativeObject.CGSizeList[1], shapeType: .rectangle(cornerRadius: 20)),
        CreatePath.createPath(size: CreativeObject.CGSizeList[2], shapeType: .rectangle(cornerRadius: 30)),
        CreatePath.createPath(size: CreativeObject.CGSizeList[0], shapeType: .triangle(cornerRadius: 18)),
        CreatePath.createPath(size: CreativeObject.CGSizeList[1], shapeType: .triangle(cornerRadius: 25)),
        CreatePath.createPath(size: CreativeObject.CGSizeList[2], shapeType: .triangle(cornerRadius: 35)),
        CreatePath.createPath(size: CreativeObject.CGSizeList_Diamond[0], shapeType: .diamond(cornerRadius: 13)),
        CreatePath.createPath(size: CreativeObject.CGSizeList_Diamond[1], shapeType: .diamond(cornerRadius: 19)),
        CreatePath.createPath(size: CreativeObject.CGSizeList_Diamond[2], shapeType: .diamond(cornerRadius: 28)),
    ]
}
