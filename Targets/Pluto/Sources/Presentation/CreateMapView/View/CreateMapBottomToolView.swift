//
//  CreateMapBottomToolView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapBottomToolView: UIView {
    
    lazy var objectView = UIImageView()
    lazy var objectUpButton = UIButton()
    lazy var objectDownButton = UIButton()
    
    lazy var objectSizeView = UIImageView()
    lazy var objectSizeUpButton = UIButton()
    lazy var objectSizeDownButton = UIButton()
    
    lazy var objectColorView = UIImageView()
    lazy var objectColorUpButton = UIButton()
    lazy var objectColorDownButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [objectView,objectUpButton, objectDownButton, objectColorView, objectColorUpButton, objectColorDownButton, objectSizeView, objectSizeUpButton, objectSizeDownButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            objectColorUpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            objectColorUpButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            objectColorUpButton.widthAnchor.constraint(equalToConstant: 100),
            objectColorUpButton.heightAnchor.constraint(equalToConstant: 20),
            
            objectColorView.leadingAnchor.constraint(equalTo: objectColorUpButton.leadingAnchor),
            objectColorView.topAnchor.constraint(equalTo: objectColorUpButton.bottomAnchor, constant: 7),
            objectColorView.widthAnchor.constraint(equalToConstant: 100),
            objectColorView.bottomAnchor.constraint(equalTo: objectColorDownButton.topAnchor, constant: -7),
            
            objectColorDownButton.leadingAnchor.constraint(equalTo: objectColorUpButton.leadingAnchor),
            objectColorDownButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            objectColorDownButton.widthAnchor.constraint(equalToConstant: 100),
            objectColorDownButton.heightAnchor.constraint(equalToConstant: 20),
            
            objectSizeUpButton.leadingAnchor.constraint(equalTo: objectColorView.trailingAnchor, constant: 19),
            objectSizeUpButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            objectSizeUpButton.widthAnchor.constraint(equalToConstant: 100),
            objectSizeUpButton.heightAnchor.constraint(equalToConstant: 20),
            
            objectSizeView.leadingAnchor.constraint(equalTo: objectSizeUpButton.leadingAnchor),
            objectSizeView.topAnchor.constraint(equalTo: objectSizeUpButton.bottomAnchor, constant: 7),
            objectSizeView.widthAnchor.constraint(equalToConstant: 100),
            objectSizeView.bottomAnchor.constraint(equalTo: objectSizeDownButton.topAnchor, constant: -7),
            
            objectSizeDownButton.leadingAnchor.constraint(equalTo: objectSizeUpButton.leadingAnchor),
            objectSizeDownButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            objectSizeDownButton.widthAnchor.constraint(equalToConstant: 100),
            objectSizeDownButton.heightAnchor.constraint(equalToConstant: 20),
            
            
            objectUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
            objectUpButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            objectUpButton.widthAnchor.constraint(equalToConstant: 100),
            objectUpButton.heightAnchor.constraint(equalToConstant: 20),
            
            objectView.leadingAnchor.constraint(equalTo: objectUpButton.leadingAnchor),
            objectView.topAnchor.constraint(equalTo: objectUpButton.bottomAnchor, constant: 7),
            objectView.widthAnchor.constraint(equalToConstant: 100),
            objectView.bottomAnchor.constraint(equalTo: objectDownButton.topAnchor, constant: -7),
            
            objectDownButton.leadingAnchor.constraint(equalTo: objectUpButton.leadingAnchor),
            objectDownButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            objectDownButton.widthAnchor.constraint(equalToConstant: 100),
            objectDownButton.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    private func setUpViews() {
        
        // Shadow
        [objectUpButton, objectDownButton, objectSizeUpButton, objectSizeDownButton, objectColorUpButton, objectColorDownButton]
            .forEach {
                $0.layer.shadowColor = UIColor.black.cgColor
                $0.layer.shadowOpacity = 0.1
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            }
        
        objectUpButton.setImage(UIImage(named: "button_up"), for: .normal)
        objectDownButton.setImage(UIImage(named: "button_down"), for: .normal)
        objectView.backgroundColor = UIColor(hex: 0xFF3434).withAlphaComponent(0.41)
        
        objectSizeUpButton.setImage(UIImage(named: "button_up"), for: .normal)
        objectSizeDownButton.setImage(UIImage(named: "button_down"), for: .normal)
        objectSizeView.backgroundColor = UIColor(hex: 0xFF3434).withAlphaComponent(0.41)
        
        objectColorUpButton.setImage(UIImage(named: "button_up"), for: .normal)
        objectColorDownButton.setImage(UIImage(named: "button_down"), for: .normal)
        objectColorView.backgroundColor = UIColor(hex: 0xFF3434).withAlphaComponent(0.41)
        
    }
    
    
}
