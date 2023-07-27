//
//  TutorialView.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/26.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var activates: [Activate] = []
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage = UIImage()
    let backgroundView = UIView()
    
    private var counterColockWiseButton: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 38, y: 682), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        view.layer.cornerRadius = view.bounds.width / 2.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private var changeGreenButton: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 251, y: 682), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        view.layer.cornerRadius = view.bounds.width / 2.0
        view.clipsToBounds = true
        
        return view
    }()
    
    private var clockWiseButton: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 251, y: 61), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private var changeRedButton: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 38, y: 61), size: CGSize(width: 100, height: 100)))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private var pauseButton: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: -145.5, y: 327.5), size: CGSize(width: 190, height: 190)))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private var throatGagueOneButton: UIView = {
        let view = UIView(frame: CGRect(x: 259, y: 628, width: 122.5, height: 36))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        
        return view
    }()
    
    private var throatGagueTwoButton: UIView = {
        let view = UIView(frame: CGRect(x: 255, y: 180, width: 122.5, height: 36))
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        
        return view
    }()
    
    private var onePlayerCharacter: UIImageView = {
        let image = UIImage(named: "FailImage")
        let imageView = UIImageView(image: image!)
        
        return imageView
    }()
    
    private lazy var onePlayerMessage: TypewriterAnimationLabel = {
        let label = TypewriterAnimationLabel()
        label.initText = bottomText
        
        return label
    }()
    
    private lazy var onePlayerMessageRetangle: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        view.addSubview(onePlayerMessage)
        onePlayerMessage.translatesAutoresizingMaskIntoConstraints = false
        
        onePlayerMessage.topAnchor.constraint(equalTo: view.topAnchor)
            
        return view
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchPoint = touch.location(in: self)
    
            if counterColockWiseButton.isTouch(in: touchPoint) {
                counterColockWiseButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .turnCounterClockWise })
            }
            if changeGreenButton.isTouch(in: touchPoint) {
                changeGreenButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .changeGreen })
            }
            if clockWiseButton.isTouch(in: touchPoint) {
                clockWiseButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .turnClockWise })
            }
            if changeRedButton.isTouch(in: touchPoint) {
                changeRedButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .changeRed })
            }
            if pauseButton.isTouch(in: touchPoint) {
                pauseButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .pauseButton })
            }
            if throatGagueOneButton.isTouch(in: touchPoint) {
                throatGagueOneButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .ThroatGagueOne })
            }
            if throatGagueTwoButton.isTouch(in: touchPoint) {
                throatGagueTwoButton.backgroundColor = bgColor
                activates.removeAll(where: { $0 == .ThroatGagueTwo })
            }
            if activates.isEmpty {
                self.removeFromSuperview()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        removeCircle()
        layout()
    }
    
    func layout() {
        [backgroundView,
         counterColockWiseButton,
         clockWiseButton,
         changeRedButton,
         changeGreenButton,
         pauseButton,
         throatGagueOneButton,
         throatGagueTwoButton,
         onePlayerCharacter].forEach { addSubview($0) }
        
        // backgroundView
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        // onePlayerCharacter
        onePlayerCharacter.translatesAutoresizingMaskIntoConstraints = false
        
        onePlayerCharacter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        onePlayerCharacter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -240).isActive = true
        onePlayerCharacter.widthAnchor.constraint(equalToConstant: 100).isActive = true
        onePlayerCharacter.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func removeCircle() {
        
        let boundsPath = UIBezierPath(rect: bounds)
        
        for activate in Activate.allCases {
            if activates.contains(where: { $0 == activate }) {
                boundsPath.append(activate.path)
            }
            else {
                switch activate {
                case .turnClockWise:
                    clockWiseButton.backgroundColor = bgColor
                case .turnCounterClockWise:
                    counterColockWiseButton.backgroundColor = bgColor
                case .changeGreen:
                    changeGreenButton.backgroundColor = bgColor
                case .changeRed:
                    changeRedButton.backgroundColor = bgColor
                case .pauseButton:
                    pauseButton.backgroundColor = bgColor
                case .ThroatGagueOne:
                    throatGagueOneButton.backgroundColor = bgColor
                case .ThroatGagueTwo:
                    throatGagueTwoButton.backgroundColor = bgColor
                }
            }
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = boundsPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        backgroundView.layer.mask = maskLayer
        backgroundView.layer.backgroundColor = bgColor.cgColor
    }
}

extension TutorialView {
    
    enum Activate: CaseIterable {
        case turnClockWise
        case turnCounterClockWise
        case changeGreen
        case changeRed
        case pauseButton
        case ThroatGagueOne
        case ThroatGagueTwo
        
        var path: UIBezierPath {
            switch self {
            case .turnClockWise:
                let circleFrame = CGRect(x: 251, y: 61, width: 100, height: 100)
                return UIBezierPath(ovalIn: circleFrame)
            case .turnCounterClockWise:
                let circleFrame = CGRect(x: 38, y: 682, width: 100, height: 100)
                return UIBezierPath(ovalIn: circleFrame)
            case .changeGreen:
                let circleFrame = CGRect(x: 251, y: 682, width: 100, height: 100)
                return UIBezierPath(ovalIn: circleFrame)
            case .changeRed:
                let circleFrame = CGRect(x: 38, y: 61, width: 100, height: 100)
                return UIBezierPath(ovalIn: circleFrame)
            case .pauseButton:
                let circleFrame = CGRect(x: -145.5, y: 327.5, width: 190, height: 190)
                return UIBezierPath(ovalIn: circleFrame)
            case .ThroatGagueOne:
                let rectangle = CGRect(x: 259, y: 628, width: 122.5, height: 36)
                return UIBezierPath(rect: rectangle)
            case .ThroatGagueTwo:
                let rectangle = CGRect(x: 255, y: 180, width: 122.5, height: 36)
                return UIBezierPath(rect: rectangle)
            }
        }
    }
}
