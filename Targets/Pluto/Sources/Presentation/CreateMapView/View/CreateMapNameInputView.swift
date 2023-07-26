//
//  CreateMapNameInputView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/17.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapNameInputView: UIView {
    lazy var imageView = UIImageView()
    lazy var nameDescription = UILabel()
    lazy var nameTextField = UITextField()
    lazy var saveButton = UIButton()
    lazy var backButton = UIButton()
    
    let gridSize: CGFloat = 20.0
    let gridContainerView = UIView()
    var isGridDrawn = false // 그리드가 이미 그려졌는지 확인하기 위한 플래그
    
    init() {
        super.init(frame: .zero)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func addSubviews() {
        [imageView, nameDescription, nameTextField, saveButton, backButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 43),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.widthAnchor.constraint(equalToConstant: 209),
            saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -283),
            
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            nameTextField.widthAnchor.constraint(equalToConstant: 280),
            nameTextField.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -40),
            
            nameDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameDescription.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -45),
            
            imageView.bottomAnchor.constraint(equalTo: self.nameDescription.topAnchor, constant: -30),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
        ])
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        
        imageView.image = UIImage(named: "nametag")
        
        nameDescription.text = "Name your journey"
        nameDescription.textAlignment = .center
        nameDescription.numberOfLines = 1
        nameDescription.font = UIFont(name: "TASAExplorer-Bold", size: 28)
        nameDescription.textColor = SettingData().selectedTheme.white.uiColor
        
        nameTextField.setNameTextField(with: UIImage(named: "x_mark")!, mode: .whileEditing)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "TASAExplorer-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0),
            .foregroundColor: SettingData().selectedTheme.main.uiColor
        ]
        let discardButtonString = NSAttributedString(string: "save", attributes: attributes)
        saveButton.setAttributedTitle(discardButtonString, for: .normal)
        saveButton.setTitleColor(SettingData().selectedTheme.main.uiColor, for: .normal)
        saveButton.backgroundColor = SettingData().selectedTheme.white.uiColor
        saveButton.layer.cornerRadius = 22.5
        
        backButton.setImage(UIImage(named: "L_arrow_white"), for: .normal)
        backButton.tintColor = SettingData().selectedTheme.white.uiColor
        backButton.layer.cornerRadius = 15
    }
    
    private func drawGrid() {
        gridContainerView.backgroundColor = UIColor.clear // 그리드 컨테이너 뷰의 배경색을 투명하게 설정
        
        // 그리드 컨테이너 뷰의 frame 설정
        gridContainerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        // 가로 선 그리기
        for y in stride(from: 0, to: self.bounds.height, by: gridSize) {
            let lineView = UIView()
            lineView.backgroundColor = SettingData().selectedTheme.grid.uiColor
            lineView.frame = CGRect(x: 0, y: y, width: self.bounds.width, height: 1)
            gridContainerView.addSubview(lineView)
        }
        
        // 세로 선 그리기
        for x in stride(from: 0, to: self.bounds.width, by: gridSize) {
            let lineView = UIView()
            lineView.backgroundColor = SettingData().selectedTheme.grid.uiColor
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
}

