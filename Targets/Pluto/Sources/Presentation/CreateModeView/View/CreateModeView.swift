//
//  CreateModeView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateModeView: UIView {
    lazy var backButton = UIButton()
    lazy var titleLabel = UILabel()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        return layout
    }()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    
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
        [collectionView, backButton, titleLabel]
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
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 37),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

        ])
    }
    
    private func setUpViews() {
        
        backButton.setImage(UIImage(named: "L_arrow_white"), for: .normal)
        
        titleLabel.text = "creative"
        titleLabel.font = UIFont(name: "TASAExplorer-Black", size: 30)
        titleLabel.textColor = .white

        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = UIColor(hex: 0x002EFE)
        
        collectionView.register(CreateModeSelectCollectionViewCell.self, forCellWithReuseIdentifier: CreateModeSelectCollectionViewCell.identifier)
        
    }
    
}


