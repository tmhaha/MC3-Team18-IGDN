//
//  CreatePath.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/19.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import CoreGraphics
import UIKit


struct CreatePath {
    enum ShapeType {
        case rectangle(cornerRadius: CGFloat)
        case diamond(cornerRadius: CGFloat)
        case triangle(cornerRadius: CGFloat)
        case circle
    }
    
    func createPath(size: CGSize, shapeType: ShapeType) -> CGPath {
        var path = UIBezierPath()
        
        switch shapeType {
        case .rectangle(let cornerRadius):
            path = roundedPolygonPath(square: CGRect(origin: CGPoint(x: 0, y: 0), size: size), lineWidth: 1.0, sides: 4, cornerRadius: cornerRadius)
            
        case .diamond(let cornerRadius):
            let width = size.width
            let height = size.height
            let theta = atan(size.height / size.width)

            path.move(to: CGPoint(x: width / 2 - cornerRadius * sin(theta), y: cornerRadius * (1 - cos(theta))))
            path.addLine(to: CGPoint(x: cornerRadius * (1 - sin(theta)), y: height / 2 - cornerRadius * cos(theta)))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: height / 2), radius: cornerRadius, startAngle: .pi*2 - (.pi/2+theta), endAngle: .pi*2 - (.pi*3/2 - theta), clockwise: false)
            path.addLine(to: CGPoint(x: width / 2 - cornerRadius * sin(theta), y: height - cornerRadius * (1 - cos(theta))))
            path.addArc(withCenter: CGPoint(x: width / 2, y: height - cornerRadius), radius: cornerRadius, startAngle: .pi*2 - (.pi*3/2 - theta), endAngle: .pi*2 - (.pi*3/2 + theta), clockwise: false)
            path.addLine(to: CGPoint(x: width - (cornerRadius * (1 - sin(theta))), y: height / 2 + cornerRadius * cos(theta)))
            path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height / 2), radius: cornerRadius, startAngle: .pi*2 - (.pi*3/2 + theta), endAngle: .pi*2 - (.pi/2 - theta), clockwise: false)
            path.addLine(to: CGPoint(x: width / 2 + cornerRadius * sin(theta), y: cornerRadius * (1 - cos(theta))))
            path.addArc(withCenter: CGPoint(x: width / 2, y: cornerRadius), radius: cornerRadius, startAngle: .pi*2 - (.pi/2 - theta), endAngle: .pi*2 - (.pi/2 + theta), clockwise: false)

        case .triangle(let cornerRadius):
            path = roundedPolygonPath(square: CGRect(origin: CGPoint(x: 0, y: 0), size: size), lineWidth: 1.0, sides: 3, cornerRadius: cornerRadius)
            
        case .circle:
            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            let radius = min(size.width, size.height) * 0.5
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            path.close()
            
        }
        return path.cgPath
    }
    
    func roundedPolygonPath(square: CGRect, lineWidth: Double, sides: Int, cornerRadius:Double) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let theta = 2.0 * Double.pi / Double(sides)
        let offset = cornerRadius * tan(theta / 2.0)
        let squareWidth = min(Double(square.size.width), Double(square.size.height))
        var length = squareWidth - lineWidth
        
        if sides % 4 != 0 {
            length = length * cos(theta / 2.0) + offset/2.0
        }
        let sideLength = length * tan(theta / 2.0)
        
        var point = CGPointMake(CGFloat(squareWidth / 2.0 + sideLength / 2.0 - offset),
                                CGFloat(squareWidth - (squareWidth - length) / 2.0))
        var angle = Double.pi
        path.move(to: point)

        for side in 0..<sides {
            point = CGPointMake(CGFloat(Double(point.x) + (sideLength - offset * 2.0) * cos(angle)),
                                CGFloat(Double(point.y) + (sideLength - offset * 2.0) * sin(angle)))
            path.addLine(to: point)
            let center = CGPointMake(CGFloat(Double(point.x) + cornerRadius * cos(angle + Double.pi / 2)),
                                     CGFloat(Double(point.y) + cornerRadius * sin(angle + Double.pi / 2)))
            path.addArc(withCenter: center, radius: CGFloat(cornerRadius), startAngle: CGFloat(angle - Double.pi / 2), endAngle: CGFloat(angle + theta - Double.pi / 2), clockwise: true)
            point = path.currentPoint // we don't have to calculate where the arc ended ... UIBezierPath did that for us
            angle += theta
        }
        path.close()

        return path
    }
}
