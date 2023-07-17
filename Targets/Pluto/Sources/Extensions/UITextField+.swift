//
//  UITextField+.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/17.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        
    }
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
        
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
    func setNameTextField() {
        self.addLeftPadding()
        self.addRightPadding()
        self.setPlaceholderColor(UIColor(hex: 0xA3A3A3))
        self.textColor = UIColor(hex: 0xA3A3A3)
        self.font = UIFont(name: "TASAExplorer-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        self.autocapitalizationType = .none
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
    }
}
