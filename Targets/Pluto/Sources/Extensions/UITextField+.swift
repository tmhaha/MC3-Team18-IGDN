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
    
    func setNameTextField(with image: UIImage, mode: UITextField.ViewMode) {
        self.addLeftPadding()
        self.addRightPadding()
        self.placeholder = "ex)Mother planet"
        self.setPlaceholderColor(UIColor(hex: 0xA3A3A3))
        self.textColor = UIColor(hex: 0xA3A3A3)
        self.font = UIFont(name: "TASAExplorer-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        self.autocapitalizationType = .none
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        
        let rightView = UIView(frame: CGRectMake(-10, 0, 45, 45))
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        clearButton.setImage(image, for: .normal)
        clearButton.tintColor = UIColor(hex: 0x2244FF)
        clearButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 25), forImageIn: .normal)
        clearButton.imageView?.contentMode = .scaleAspectFit
        
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        rightView.addSubview(clearButton)
        self.rightView = rightView
        self.rightViewMode = mode
        
    }
    
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
    }
}
