//
//  GameAlertViewController.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/17.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class GameAlertView: UIView {
    
    var alertType: GameAlertType
    var upCompletion: (() -> Void)?
    var downCompletion: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setting()
    }
    
    init(frame: CGRect, alertType: GameAlertType) {
        self.alertType = alertType
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting() {
        
        backgroundColor = alertType.backgroundColor
        
        //titleImageView
        let titleImageView = UIImageView(image: alertType.titleImage)
        titleImageView.frame = .zero// CGRect(x: 0, y: 0, width: 100, height: 80)
        addSubview(titleImageView)
        
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        titleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 265).isActive = true

        //upButton
        let upButton = UIView()
        addSubview(upButton)
        upButton.translatesAutoresizingMaskIntoConstraints = false
        
        upButton.frame = .zero
        upButton.layer.backgroundColor = UIColor.white.cgColor
        upButton.layer.cornerRadius = 20
        upButton.layer.borderWidth = 1
        upButton.layer.borderColor = UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1).cgColor

        upButton.translatesAutoresizingMaskIntoConstraints = false
        upButton.widthAnchor.constraint(equalToConstant: 209).isActive = true
        upButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        upButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        upButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 510).isActive = true
        
        let tapUpButton = UITapGestureRecognizer(target: self, action: #selector(tapUpButton))
        upButton.addGestureRecognizer(tapUpButton)
        
        //label in upButton
        let labelInUpButton = UILabel()
        upButton.addSubview(labelInUpButton)
        labelInUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        labelInUpButton.frame = .zero//CGRect(x: 0, y: 0, width: 76.56, height: 21)
        labelInUpButton.textColor = UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1)
        labelInUpButton.textAlignment = .center
        labelInUpButton.text = alertType.upButtonTitle
        
        labelInUpButton.translatesAutoresizingMaskIntoConstraints = false
        labelInUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        labelInUpButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        labelInUpButton.centerXAnchor.constraint(equalTo: upButton.centerXAnchor, constant: 0).isActive = true
        labelInUpButton.centerYAnchor.constraint(equalTo: upButton.centerYAnchor, constant: 0).isActive = true
        
        
        // image in upbutton
        let imageInUpButton = UIImageView()
        upButton.addSubview(imageInUpButton)
        imageInUpButton.image = alertType.upButtonIcon
        imageInUpButton.translatesAutoresizingMaskIntoConstraints = false
        imageInUpButton.frame = .zero//CGRect(x: 0, y: 0, width: 21, height: 21)
        imageInUpButton.tintColor = UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1)
        
        imageInUpButton.translatesAutoresizingMaskIntoConstraints = false
        imageInUpButton.widthAnchor.constraint(equalToConstant: 21).isActive = true
        imageInUpButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        imageInUpButton.centerYAnchor.constraint(equalTo: upButton.centerYAnchor, constant: 0).isActive = true
        imageInUpButton.trailingAnchor.constraint(equalTo: upButton.trailingAnchor, constant: -15).isActive = true
        
        //bottomButton
        let bottomButton = UIView()
        addSubview(bottomButton)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomButton.frame = .zero//CGRect(x: 0, y: 0, width: 209, height: 43)
        bottomButton.layer.backgroundColor = UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1).cgColor
        bottomButton.layer.cornerRadius = 20
        bottomButton.layer.borderWidth = 1
        bottomButton.layer.borderColor = UIColor(red: 0, green: 0.18, blue: 0.996, alpha: 1).cgColor
        
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.widthAnchor.constraint(equalToConstant: 209).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bottomButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        bottomButton.topAnchor.constraint(equalTo: upButton.bottomAnchor, constant: 10).isActive = true
        
        let tapBottomButton = UITapGestureRecognizer(target: self, action: #selector(tapBottomButton))
        bottomButton.addGestureRecognizer(tapBottomButton)
        
        //label in bottomButton
        let labelInBottomButton = UILabel()
        bottomButton.addSubview(labelInBottomButton)
        labelInBottomButton.frame = .zero // CGRect(x: 0, y: 0, width: 122.09, height: 21)
        labelInBottomButton.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        labelInBottomButton.text = alertType.downButtonTitle
        labelInBottomButton.textAlignment = .center
        
        labelInBottomButton.translatesAutoresizingMaskIntoConstraints = false
        labelInBottomButton.widthAnchor.constraint(equalToConstant: 122.09).isActive = true
        labelInBottomButton.heightAnchor.constraint(equalToConstant: 21).isActive = true
        labelInBottomButton.centerXAnchor.constraint(equalTo: bottomButton.centerXAnchor).isActive = true
        labelInBottomButton.centerYAnchor.constraint(equalTo: bottomButton.centerYAnchor).isActive = true
        
        
        //titleLabel
        let titleLabel = UILabel()
        titleLabel.frame = .zero//CGRect(x: 0, y: 0, width: 171, height: 58)
        titleLabel.textColor = alertType.titleColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 50) // 기본 폰트 크기
        
        titleLabel.text = alertType.title
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 58).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 374).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @objc func tapUpButton(_ sender: Any) {
        upCompletion!()
    }
    
    @objc func tapBottomButton(_ sender: Any) {
        downCompletion!()
    }
}
