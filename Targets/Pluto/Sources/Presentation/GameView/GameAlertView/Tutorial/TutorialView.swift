//
//  TutorialView.swift
//  Pluto
//
//  Created by changgyo seo on 2023/07/26.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    var isFinished = false
    var tutorialFinishDelegate: TutorialFinishDelegate? = nil
    var currentIndex = 0
    var currentHasActivateButton = false
    let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    var activates: [[Activate]] = [[]]
    var topText: [String] = []
    var bottomText: [String] = []
    var image: [UIImage] = []
    var lastPoint: CGPoint = CGPoint()
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
        let image = UIImage(named: "SystemBubble")
        let imageView = UIImageView(image: image!)
        
        return imageView
    }()
    
    private var onePlayerMessageRetangle: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private var onePlayerMessage: TypewriterAnimationLabel = {
        let label = TypewriterAnimationLabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private var twoPlayerCharacter: UIImageView = {
        let image = UIImage(named: "SystemBubble")
        let imageView = UIImageView(image: image!)
        
        return imageView
    }()
    
    private var twoPlayerMessageRetangle: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private var twoPlayerMessage: TypewriterAnimationLabel = {
        let label = TypewriterAnimationLabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    private var centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    func cute(_ x: Int) {
        print("@SEO \(x)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchPoint = touch.location(in: self)
            print("@SEO TOUCHE")
            if counterColockWiseButton.isTouch(in: touchPoint) {
                counterColockWiseButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .turnCounterClockWise })
            }
            if changeGreenButton.isTouch(in: touchPoint) {
                changeGreenButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .changeGreen })
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 2)
//                if isFinished {
//                    tutorialFinishDelegate?.finish(touches, with: event, endedType: 2)
//                }
            }
            if clockWiseButton.isTouch(in: touchPoint) {
                clockWiseButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .turnClockWise })
            }
            if changeRedButton.isTouch(in: touchPoint) {
                changeRedButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .changeRed })
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 2)
//                if isFinished {
//                    tutorialFinishDelegate?.finish(touches, with: event, endedType: 2)
//                }
            }
            if pauseButton.isTouch(in: touchPoint) {
                pauseButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .pauseButton })
                if isFinished {
                    tutorialFinishDelegate?.finish(touches, with: event, endedType: 2)
                }
            }
            if throatGagueOneButton.isTouch(in: touchPoint) {
                throatGagueOneButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .ThroatGagueOne })
            }
            if throatGagueTwoButton.isTouch(in: touchPoint) {
                throatGagueTwoButton.backgroundColor = bgColor
                activates[currentIndex].removeAll(where: { $0 == .ThroatGagueTwo })
            }
            if activates[currentIndex].isEmpty && currentIndex + 1 < topText.count {
                currentIndex += 1
                startCurrentTutorial()
            }
            else if activates[currentIndex].isEmpty && !isFinished {
                cute(1)
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 1)
                isFinished = true
                lastPoint = touchPoint
                removeFromSuperview()
                for view in subviews {
                    view.alpha = 0
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches {
            
            let touchPoint = touch.location(in: self)
            
            if counterColockWiseButton.isTouch(in: touchPoint) && counterColockWiseButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            else if changeGreenButton.isTouch(in: touchPoint) && changeGreenButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            if clockWiseButton.isTouch(in: touchPoint) && clockWiseButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            if changeRedButton.isTouch(in: touchPoint) && changeRedButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            if pauseButton.isTouch(in: touchPoint) && pauseButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            if throatGagueOneButton.isTouch(in: touchPoint) && throatGagueOneButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
            }
            if throatGagueTwoButton.isTouch(in: touchPoint) && throatGagueTwoButton.isTouch(in: lastPoint) {
                tutorialFinishDelegate?.finish(touches, with: event, endedType: 3)
                removeFromSuperview()
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
        layout()
        startCurrentTutorial()
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
         onePlayerCharacter,
         onePlayerMessageRetangle,
         twoPlayerCharacter,
         twoPlayerMessageRetangle,
         centerImageView].forEach { addSubview($0) }
        
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
        onePlayerCharacter.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // onePlayerMessageRetangle
        onePlayerMessageRetangle.translatesAutoresizingMaskIntoConstraints = false
        
        onePlayerMessageRetangle.leadingAnchor.constraint(equalTo: onePlayerCharacter.trailingAnchor, constant: 20).isActive = true
        onePlayerMessageRetangle.bottomAnchor.constraint(equalTo: onePlayerCharacter.bottomAnchor).isActive = true
        onePlayerMessageRetangle.widthAnchor.constraint(equalToConstant: 240).isActive = true
        onePlayerMessageRetangle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // onePlayerMessage
        onePlayerMessageRetangle.addSubview(onePlayerMessage)
        
        onePlayerMessage.translatesAutoresizingMaskIntoConstraints = false
        
        onePlayerMessage.leadingAnchor.constraint(equalTo: onePlayerMessageRetangle.leadingAnchor, constant: 14).isActive = true
        onePlayerMessage.topAnchor.constraint(equalTo: onePlayerMessageRetangle.topAnchor, constant: 14).isActive = true
        onePlayerMessage.trailingAnchor.constraint(equalTo: onePlayerMessageRetangle.trailingAnchor, constant: -14).isActive = true
        onePlayerMessage.bottomAnchor.constraint(equalTo: onePlayerMessageRetangle.bottomAnchor, constant: -14).isActive = true
        
        // rotation degree
        let rotationDegree = CGFloat.pi
        
        // twoPlayerMessageRetangle
        twoPlayerCharacter.translatesAutoresizingMaskIntoConstraints = false
        
        twoPlayerCharacter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
        twoPlayerCharacter.topAnchor.constraint(equalTo: topAnchor, constant: 240).isActive = true
        twoPlayerCharacter.widthAnchor.constraint(equalToConstant: 100).isActive = true
        twoPlayerCharacter.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        twoPlayerCharacter.transform = CGAffineTransform(rotationAngle: rotationDegree)
        
        // twoPlayerMessageRetangle
        twoPlayerMessageRetangle.translatesAutoresizingMaskIntoConstraints = false
        
        twoPlayerMessageRetangle.topAnchor.constraint(equalTo: twoPlayerCharacter.topAnchor).isActive = true
        twoPlayerMessageRetangle.trailingAnchor.constraint(equalTo: twoPlayerCharacter.leadingAnchor, constant: -20).isActive = true
        twoPlayerMessageRetangle.widthAnchor.constraint(equalToConstant: 240).isActive = true
        twoPlayerMessageRetangle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // twoPlayerMessage
        twoPlayerMessageRetangle.addSubview(twoPlayerMessage)
        
        twoPlayerMessage.translatesAutoresizingMaskIntoConstraints = false
        
        twoPlayerMessage.leadingAnchor.constraint(equalTo: twoPlayerMessageRetangle.leadingAnchor, constant: 14).isActive = true
        twoPlayerMessage.topAnchor.constraint(equalTo: twoPlayerMessageRetangle.topAnchor, constant: 14).isActive = true
        twoPlayerMessage.trailingAnchor.constraint(equalTo: twoPlayerMessageRetangle.trailingAnchor, constant: -14).isActive = true
        twoPlayerMessage.bottomAnchor.constraint(equalTo: twoPlayerMessageRetangle.bottomAnchor, constant: -14).isActive = true
        
        twoPlayerMessage.transform = CGAffineTransform(rotationAngle: rotationDegree)
        
        // centerImageView
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func startCurrentTutorial() {
        onePlayerMessage.initText = bottomText[currentIndex]
        onePlayerMessage.textColor = .black
        onePlayerMessage.startTypewriterAnimation()
        
        twoPlayerMessage.initText = topText[currentIndex]
        twoPlayerMessage.textColor = .black
        twoPlayerMessage.startTypewriterAnimation()
        
        centerImageView.image = image[currentIndex]
        
        currentHasActivateButton = activates.count == 0 ? false : true
        
        removeCircle()
    }
    
    func removeCircle() {
        
        let boundsPath = UIBezierPath(rect: bounds)
        
        for activate in Activate.allCases {
            if activates[currentIndex].contains(where: { $0 == activate }) {
                boundsPath.append(activate.path)
                switch activate {
                case .turnClockWise:
                    clockWiseButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .turnCounterClockWise:
                    counterColockWiseButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .changeGreen:
                    changeGreenButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .changeRed:
                    changeRedButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .pauseButton:
                    pauseButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .ThroatGagueOne:
                    throatGagueOneButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                case .ThroatGagueTwo:
                    throatGagueTwoButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                }
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
