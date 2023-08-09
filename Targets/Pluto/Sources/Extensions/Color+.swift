//
//  Extension.swift
//  MC3_Hazzy
//
//  Created by 고혜지 on 2023/07/12.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    var uiColor: UIColor {
        let uiColor: UIColor
        let components = self.components()
        uiColor = UIColor(red: components.red,
                          green: components.green,
                          blue: components.blue,
                          alpha: components.opacity)
        return uiColor
    }
    
    private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        
        if let cgColor = self.cgColor {
            let colorSpace = cgColor.colorSpace
            let rgba = cgColor.components
            
            if colorSpace?.model == .rgb, rgba!.count >= 4 {
                red = rgba![0]
                green = rgba![1]
                blue = rgba![2]
                opacity = rgba![3]
            }
        }
        return (red: red, green: green, blue: blue, opacity: opacity)
    }
}
