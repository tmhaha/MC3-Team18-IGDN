//
//  CreateModeView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateModeView: UIView {
    lazy var selectMapButton = UIButton()
    lazy var createMapButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        isUserInteractionEnabled = false
        
    }
    
    func finishLoading() {
        isUserInteractionEnabled = true
        
    }
    
    private func addSubviews() {
        [selectMapButton, createMapButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            selectMapButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectMapButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30.0),
            selectMapButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0),
            selectMapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0),
            selectMapButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            createMapButton.topAnchor.constraint(equalTo: selectMapButton.bottomAnchor, constant: 10.0),
            createMapButton.centerXAnchor.constraint(equalTo: selectMapButton.centerXAnchor),
            createMapButton.widthAnchor.constraint(equalTo: selectMapButton.widthAnchor, multiplier: 1.0),
            createMapButton.heightAnchor.constraint(equalTo: selectMapButton.heightAnchor),
        ])
    }
    
    private func setUpViews() {
        self.backgroundColor = .systemBackground
        
        selectMapButton.setTitle("Select Map", for: .normal)
        selectMapButton.setTitleColor(.black, for: .normal)
        
        createMapButton.setTitle("Create Map", for: .normal)
        createMapButton.setTitleColor(.black, for: .normal)
    }
}
