//
//  CreateMapBottomToolView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapBottomToolView: UIView {
    
    lazy var objectColorView = UIView()
    lazy var objectShapeView = UIView()
    lazy var objectSizeView = UIView()
    
    lazy var objectColorImageView = UIImageView()
    lazy var objectShapeImageView = UIImageView()
    lazy var objectSizeImageView = UIImageView()
    
    lazy var objectColorUpButton = UIButton()
    lazy var objectShapeUpButton = UIButton()
    lazy var objectSizeUpButton = UIButton()
    
    lazy var objectColorDownButton = UIButton()
    lazy var objectShapeDownButton = UIButton()
    lazy var objectSizeDownButton = UIButton()
    
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
        [objectColorView, objectShapeView, objectSizeView]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [objectColorUpButton, objectColorDownButton, objectColorImageView]
            .forEach {
                objectColorView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        [objectShapeUpButton, objectShapeDownButton, objectShapeImageView]
            .forEach {
                objectShapeView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        [objectSizeUpButton, objectSizeDownButton, objectSizeImageView]
            .forEach {
                objectSizeView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = SettingData().selectedTheme.white.uiColor
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            objectColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            objectColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            objectColorView.widthAnchor.constraint(equalToConstant: 110),
            objectColorView.heightAnchor.constraint(equalToConstant: 100),

            objectShapeView.leadingAnchor.constraint(equalTo: objectColorView.trailingAnchor, constant: 12),
            objectShapeView.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectShapeView.widthAnchor.constraint(equalToConstant: 110),
            objectShapeView.heightAnchor.constraint(equalToConstant: 100),
            
            objectSizeView.leadingAnchor.constraint(equalTo: objectShapeView.trailingAnchor, constant: 12),
            objectSizeView.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectSizeView.widthAnchor.constraint(equalToConstant: 110),
            objectSizeView.heightAnchor.constraint(equalToConstant: 100),
            
            objectColorImageView.leadingAnchor.constraint(equalTo: objectColorView.leadingAnchor),
            objectColorImageView.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectColorImageView.widthAnchor.constraint(equalToConstant: 110),
            objectColorImageView.heightAnchor.constraint(equalToConstant: 100),

            objectShapeImageView.leadingAnchor.constraint(equalTo: objectColorView.trailingAnchor, constant: 12),
            objectShapeImageView.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectShapeImageView.widthAnchor.constraint(equalToConstant: 110),
            objectShapeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            objectSizeImageView.leadingAnchor.constraint(equalTo: objectShapeView.trailingAnchor, constant: 12),
            objectSizeImageView.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectSizeImageView.widthAnchor.constraint(equalToConstant: 110),
            objectSizeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            objectColorUpButton.leadingAnchor.constraint(equalTo: objectColorView.leadingAnchor),
            objectColorUpButton.topAnchor.constraint(equalTo: objectColorView.topAnchor),
            objectColorUpButton.trailingAnchor.constraint(equalTo: objectColorView.trailingAnchor),
            objectColorUpButton.heightAnchor.constraint(equalToConstant: 50),
            objectColorUpButton.widthAnchor.constraint(equalToConstant: 110),
            
            objectColorDownButton.leadingAnchor.constraint(equalTo: objectColorView.leadingAnchor),
            objectColorDownButton.bottomAnchor.constraint(equalTo: objectColorView.bottomAnchor),
            objectColorDownButton.trailingAnchor.constraint(equalTo: objectColorView.trailingAnchor),
            objectColorDownButton.heightAnchor.constraint(equalToConstant: 50),
            objectColorDownButton.widthAnchor.constraint(equalToConstant: 110),
            
            objectShapeUpButton.leadingAnchor.constraint(equalTo: objectShapeView.leadingAnchor),
            objectShapeUpButton.topAnchor.constraint(equalTo: objectShapeView.topAnchor),
            objectShapeUpButton.trailingAnchor.constraint(equalTo: objectShapeView.trailingAnchor),
            objectShapeUpButton.heightAnchor.constraint(equalToConstant: 50),
            objectShapeUpButton.widthAnchor.constraint(equalToConstant: 110),
            
            objectShapeDownButton.leadingAnchor.constraint(equalTo: objectShapeView.leadingAnchor),
            objectShapeDownButton.bottomAnchor.constraint(equalTo: objectShapeView.bottomAnchor),
            objectShapeDownButton.trailingAnchor.constraint(equalTo: objectShapeView.trailingAnchor),
            objectShapeDownButton.heightAnchor.constraint(equalToConstant: 50),
            objectShapeDownButton.widthAnchor.constraint(equalToConstant: 110),
            
            objectSizeUpButton.leadingAnchor.constraint(equalTo: objectSizeView.leadingAnchor),
            objectSizeUpButton.topAnchor.constraint(equalTo: objectSizeView.topAnchor),
            objectSizeUpButton.trailingAnchor.constraint(equalTo: objectSizeView.trailingAnchor),
            objectSizeUpButton.heightAnchor.constraint(equalToConstant: 50),
            objectSizeUpButton.widthAnchor.constraint(equalToConstant: 110),
            
            objectSizeDownButton.leadingAnchor.constraint(equalTo: objectSizeView.leadingAnchor),
            objectSizeDownButton.bottomAnchor.constraint(equalTo: objectSizeView.bottomAnchor),
            objectSizeDownButton.trailingAnchor.constraint(equalTo: objectSizeView.trailingAnchor),
            objectSizeDownButton.heightAnchor.constraint(equalToConstant: 50),
            objectSizeDownButton.widthAnchor.constraint(equalToConstant: 110),
        ])
    }
    
    private func setUpViews() {
        objectColorImageView.image = UIImage(named: SettingData().selectedTheme.creativeColor[0])
        objectShapeImageView.image = UIImage(named: SettingData().selectedTheme.creativeShape[0])
        objectSizeImageView.image = UIImage(named: SettingData().selectedTheme.creativeSize[0])
    }
    
}
