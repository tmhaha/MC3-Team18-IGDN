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
        case roundedRectangle(cornerRadius: CGFloat)
        case equilateralTriangle(cornerRadius: CGFloat)
        case circle
    }

    func createPath(size: CGSize, shapeType: ShapeType) -> CGPath {
        let path = UIBezierPath()
        
        switch shapeType {
        case .rectangle(let cornerRadius):
            path.move(to: CGPoint(x: 0, y: cornerRadius))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
            path.addLine(to: CGPoint(x: size.width - cornerRadius, y: 0))
            path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: size.width, y: size.height - cornerRadius))
            path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            path.addLine(to: CGPoint(x: cornerRadius, y: size.height))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: size.height - cornerRadius), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
        case .roundedRectangle(let cornerRadius):
            path.move(to: CGPoint(x: cornerRadius, y: 0))
            path.addLine(to: CGPoint(x: size.width - cornerRadius, y: 0))
            path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: size.width, y: size.height - cornerRadius))
            path.addArc(withCenter: CGPoint(x: size.width - cornerRadius, y: size.height - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            path.addLine(to: CGPoint(x: cornerRadius, y: size.height))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: size.height - cornerRadius), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
        case .equilateralTriangle(let cornerRadius):
            let sideLength: CGFloat = size.width
            let height = sideLength * sqrt(3) / 2
            path.move(to: CGPoint(x: size.width * 0.5, y: height))
            path.addLine(to: CGPoint(x: size.width * 0.5 + sideLength * 0.5, y: 0))
            path.addLine(to: CGPoint(x: size.width * 0.5 - sideLength * 0.5, y: 0))
            path.close()
            
        case .circle:
            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
            let radius = min(size.width, size.height) * 0.5
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            path.close()
        }
        
        return path.cgPath
    }

}

///
// MARK: - 사용예시
// let size = CGSize(width: 50, height: 50)
// let cornerRadius: CGFloat = 10
// let rectanglePath = createPath(size: size, shapeType: .rectangle(cornerRadius: cornerRadius))
// let roundedRectanglePath = createPath(size: size, shapeType: .roundedRectangle(cornerRadius: cornerRadius))
// let trianglePath = createPath(size: size, shapeType: .equilateralTriangle(cornerRadius: cornerRadius))
// let circlePath = createPath(size: size, shapeType: .circle)
///
