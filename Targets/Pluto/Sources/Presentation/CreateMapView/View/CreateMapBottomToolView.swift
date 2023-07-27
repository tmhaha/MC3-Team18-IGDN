//
//  CreateMapBottomToolView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapBottomToolView: UIView {
    
    lazy var objectShapeButton = UIButton()
    lazy var objectSizeButton = UIButton()
    lazy var objectColorButton = UIButton()
    
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
        [objectShapeButton, objectColorButton, objectSizeButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = SettingData().selectedTheme.white.uiColor
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            objectColorButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            objectColorButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            objectColorButton.widthAnchor.constraint(equalToConstant: 110),
            objectColorButton.heightAnchor.constraint(equalToConstant: 100),

            objectShapeButton.leadingAnchor.constraint(equalTo: objectColorButton.trailingAnchor, constant: 12),
            objectShapeButton.topAnchor.constraint(equalTo: objectColorButton.topAnchor),
            objectShapeButton.widthAnchor.constraint(equalToConstant: 110),
            objectShapeButton.heightAnchor.constraint(equalToConstant: 100),
            
            objectSizeButton.leadingAnchor.constraint(equalTo: objectShapeButton.trailingAnchor, constant: 12),
            objectSizeButton.topAnchor.constraint(equalTo: objectColorButton.topAnchor),
            objectSizeButton.widthAnchor.constraint(equalToConstant: 110),
            objectSizeButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setUpViews() {
        objectColorButton.setImage(UIImage(named: SettingData().selectedTheme.creativeColor[0]), for: .normal)
        objectShapeButton.setImage(UIImage(named: SettingData().selectedTheme.creativeShape[0]), for: .normal)
        objectSizeButton.setImage(UIImage(named: SettingData().selectedTheme.creativeSize[0]), for: .normal)
    }
    
}
