//
//  CreateMapAlertView.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/16.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

final class CreateMapAlertView: UIView {
    lazy var alertImageView = UIImageView()
    lazy var alertDescription = UILabel()
    lazy var keepEditingButton = UIButton()
    lazy var discardButton = UIButton()
    
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
        [alertImageView, alertDescription, keepEditingButton, discardButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            discardButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            discardButton.heightAnchor.constraint(equalToConstant: 45),
            discardButton.widthAnchor.constraint(equalToConstant: 262),
            discardButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150),
            
            keepEditingButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            keepEditingButton.heightAnchor.constraint(equalToConstant: 45),
            keepEditingButton.widthAnchor.constraint(equalToConstant: 262),
            keepEditingButton.bottomAnchor.constraint(equalTo: discardButton.topAnchor, constant: -15),
            
            alertDescription.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertDescription.bottomAnchor.constraint(equalTo: keepEditingButton.topAnchor, constant: -56),
            
            alertImageView.bottomAnchor.constraint(equalTo: self.alertDescription.topAnchor, constant: -20),
            alertImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertImageView.widthAnchor.constraint(equalToConstant: 63),
            alertImageView.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    
    private func setUpViews() {
        self.backgroundColor = .clear
        
        alertImageView.image = UIImage(named: "warning")
        
        alertDescription.text = "Are you sure\ndiscard all changes?"
        alertDescription.textAlignment = .center
        alertDescription.numberOfLines = 0
        alertDescription.font = UIFont(name: "TASAExplorer-Bold", size: 28)
        alertDescription.textColor = SettingData().selectedTheme.white.uiColor
        
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "TASAExplorer-Bold", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
        ]
        
        let keepEditingButtonString = NSAttributedString(string: "keep editing", attributes: attributes)
        keepEditingButton.setAttributedTitle(keepEditingButtonString, for: .normal)
        keepEditingButton.setTitleColor(SettingData().selectedTheme.main.uiColor, for: .normal)
        keepEditingButton.backgroundColor = SettingData().selectedTheme.white.uiColor
        
        let discardButtonString = NSAttributedString(string: "discard", attributes: attributes)
        discardButton.setAttributedTitle(discardButtonString, for: .normal)
        discardButton.setTitleColor(SettingData().selectedTheme.white.uiColor, for: .normal)
        discardButton.backgroundColor = SettingData().selectedTheme.warnRed.uiColor
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
