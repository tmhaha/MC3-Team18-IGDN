//
//  UIColor+.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/13.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
