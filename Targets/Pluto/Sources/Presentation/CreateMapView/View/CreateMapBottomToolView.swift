//
//  CreateMapBottomToolView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapBottomToolView: UIView {

    var width: CGFloat = 0
    var height: CGFloat = 0
    
    lazy var colorScrollView = UIScrollView()
    lazy var sizeScrollView = UIScrollView()
    lazy var objectScrollView = UIScrollView()
    
    lazy var colorContentView = UIView()
    lazy var sizeContentView = UIView()
    lazy var objectContentView = UIView()
    
    lazy var colorStackView = UIStackView()
    lazy var sizeStackView = UIStackView()
    lazy var objectStackView = UIStackView()
    
    lazy var buttonOne = UIButton()
    lazy var buttonTwo = UIButton()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [colorScrollView, sizeScrollView, objectScrollView, buttonOne, buttonTwo]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        colorScrollView.addSubview(colorContentView)
        sizeScrollView.addSubview(sizeContentView)
        objectScrollView.addSubview(objectContentView)
        
        [colorContentView, sizeContentView, objectContentView]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        colorContentView.addSubview(colorStackView)
        sizeContentView.addSubview(sizeStackView)
        objectContentView.addSubview(objectStackView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        width = (self.bounds.width - 16 * 2) / 3
        height = width / 116 * 120
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
//            buttonOne.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
//            buttonOne.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
//            buttonOne.heightAnchor.constraint(equalToConstant: 50.0),
//            buttonOne.widthAnchor.constraint(equalToConstant: 120),
//
//            buttonTwo.leadingAnchor.constraint(equalTo: buttonOne.trailingAnchor, constant: 24),
//            buttonTwo.heightAnchor.constraint(equalTo: buttonOne.heightAnchor),
//            buttonTwo.widthAnchor.constraint(equalTo: buttonOne.widthAnchor),
//            buttonTwo.centerYAnchor.constraint(equalTo: buttonOne.centerYAnchor),
            
            colorScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            colorScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            colorScrollView.widthAnchor.constraint(equalToConstant: width),
            colorScrollView.heightAnchor.constraint(equalToConstant: height),
            
            sizeScrollView.leadingAnchor.constraint(equalTo: colorScrollView.trailingAnchor),
            sizeScrollView.bottomAnchor.constraint(equalTo: colorScrollView.bottomAnchor),
            sizeScrollView.widthAnchor.constraint(equalToConstant: width),
            sizeScrollView.heightAnchor.constraint(equalToConstant: height),
            
            objectScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            objectScrollView.bottomAnchor.constraint(equalTo: colorScrollView.bottomAnchor),
            objectScrollView.widthAnchor.constraint(equalToConstant: width),
            objectScrollView.heightAnchor.constraint(equalToConstant: height),
            
            colorContentView.leadingAnchor.constraint(equalTo: colorScrollView.leadingAnchor),
            colorContentView.trailingAnchor.constraint(equalTo: colorScrollView.trailingAnchor),
            colorContentView.bottomAnchor.constraint(equalTo: colorScrollView.bottomAnchor),
            colorContentView.topAnchor.constraint(equalTo: colorScrollView.topAnchor),
            
            sizeContentView.leadingAnchor.constraint(equalTo: sizeScrollView.leadingAnchor),
            sizeContentView.trailingAnchor.constraint(equalTo: sizeScrollView.trailingAnchor),
            sizeContentView.bottomAnchor.constraint(equalTo: sizeScrollView.bottomAnchor),
            sizeContentView.topAnchor.constraint(equalTo: sizeScrollView.topAnchor),
            
            objectContentView.leadingAnchor.constraint(equalTo: objectScrollView.leadingAnchor),
            objectContentView.trailingAnchor.constraint(equalTo: objectScrollView.trailingAnchor),
            objectContentView.bottomAnchor.constraint(equalTo: objectScrollView.bottomAnchor),
            objectContentView.topAnchor.constraint(equalTo: objectScrollView.topAnchor),
            
            colorStackView.leadingAnchor.constraint(equalTo: colorContentView.leadingAnchor),
            colorStackView.trailingAnchor.constraint(equalTo: colorContentView.trailingAnchor),
            colorStackView.topAnchor.constraint(equalTo: colorContentView.topAnchor),
            colorStackView.bottomAnchor.constraint(equalTo: colorContentView.bottomAnchor),
            
            sizeStackView.leadingAnchor.constraint(equalTo: sizeContentView.leadingAnchor),
            sizeStackView.trailingAnchor.constraint(equalTo: sizeContentView.trailingAnchor),
            sizeStackView.topAnchor.constraint(equalTo: sizeContentView.topAnchor),
            sizeStackView.bottomAnchor.constraint(equalTo: sizeContentView.bottomAnchor),
            
            objectStackView.leadingAnchor.constraint(equalTo: objectContentView.leadingAnchor),
            objectStackView.trailingAnchor.constraint(equalTo: objectContentView.trailingAnchor),
            objectStackView.topAnchor.constraint(equalTo: objectContentView.topAnchor),
            objectStackView.bottomAnchor.constraint(equalTo: objectContentView.bottomAnchor),
            
        ])
    }
    
    private func setUpViews() {
        
        buttonOne.setTitle("Button 1", for: .normal)
        buttonOne.setTitleColor(.black, for: .normal)
        buttonOne.layer.borderWidth = 2
        buttonOne.layer.borderColor = UIColor.blue.cgColor
        buttonOne.layer.cornerRadius = 15
        
        buttonTwo.setTitle("Button 2", for: .normal)
        buttonTwo.setTitleColor(.black, for: .normal)
        buttonTwo.layer.borderWidth = 2
        buttonTwo.layer.borderColor = UIColor.blue.cgColor
        buttonTwo.layer.cornerRadius = 15
        
        buttonTwo.layer.opacity = 1
        
        buttonOne.isHidden = true
        buttonTwo.isHidden = true
        
        
        colorScrollView.backgroundColor = .red
        sizeScrollView.backgroundColor = .yellow
        objectScrollView.backgroundColor = .green

    }
}
