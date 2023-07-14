//
//  CreativeObject.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/14.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

struct CreativeObject: Equatable {
    let point: CGPoint
    let color: UIColor
    let size: String
    let shape: String
    let path: CGPath
    let object: UIView
    
    static func == (lhs: CreativeObject, rhs: CreativeObject) -> Bool {
        return lhs.point == rhs.point
    }
}
