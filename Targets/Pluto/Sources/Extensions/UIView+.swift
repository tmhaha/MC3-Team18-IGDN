//
//  UIView+.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/27.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UIView {
    func isTouch(in touchPoint: CGPoint) -> Bool {
        return frame.origin.x <= touchPoint.x && touchPoint.x <= frame.origin.x + frame.width && frame.origin.y <= touchPoint.y && touchPoint.y <= frame.origin.y + frame.height
    }
}
