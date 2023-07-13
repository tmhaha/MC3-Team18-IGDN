//
//  CreateMapTopToolView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapTopToolView: UIView {
    lazy var backButton = UIButton()
    lazy var saveButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [backButton, saveButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([            
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 42),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalTo: backButton.heightAnchor),
            saveButton.widthAnchor.constraint(equalTo: backButton.widthAnchor),
            saveButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
        ])
    }
    
    private func setUpViews() {
        self.backgroundColor = .systemBackground
        
        backButton.setImage(UIImage(named: "L_arrow_white"), for: .normal)
        backButton.tintColor = .white
        backButton.layer.cornerRadius = 15
        
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 15

    }
}
