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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return layout
    }()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    let gridSize: CGFloat = 20.0
    let gridContainerView = UIView()
    var isGridDrawn = false // 그리드가 이미 그려졌는지 확인하기 위한 플래그
    
    init() {
        super.init(frame: .zero)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 그리드가 이미 그려진 경우 다시 그리지 않음
        guard !isGridDrawn else {
            return
        }
        
        drawGrid()
        isGridDrawn = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubviews()
        setUpConstraints()
        setUpViews()
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
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 43),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

        ])
    }
    
    private func drawGrid() {
        gridContainerView.backgroundColor = UIColor.clear // 그리드 컨테이너 뷰의 배경색을 투명하게 설정
        
        // 그리드 컨테이너 뷰의 frame 설정
        gridContainerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        // 가로 선 그리기
        for y in stride(from: 0, to: self.bounds.height, by: gridSize) {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hex: 0x4061F8)
            lineView.frame = CGRect(x: 0, y: y, width: self.bounds.width, height: 1)
            gridContainerView.addSubview(lineView)
        }
        
        // 세로 선 그리기
        for x in stride(from: 0, to: self.bounds.width, by: gridSize) {
            let lineView = UIView()
            lineView.backgroundColor = UIColor(hex: 0x4061F8)
            lineView.frame = CGRect(x: x, y: 0, width: 1, height: self.bounds.height)
            gridContainerView.addSubview(lineView)
        }
        
        // 그리드 컨테이너 뷰를 contentView에 추가
        self.addSubview(gridContainerView)
        gridContainerView.translatesAutoresizingMaskIntoConstraints = false
        gridContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gridContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gridContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
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
//        collectionView.backgroundColor = UIColor(hex: 0x2244FF)
        collectionView.backgroundColor = .clear
        
        collectionView.register(CreateModeSelectCollectionViewCell.self, forCellWithReuseIdentifier: CreateModeSelectCollectionViewCell.identifier)
        
    }
    
}


