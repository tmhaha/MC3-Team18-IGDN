//
//  CreateMapViewController.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import Combine

class CreateMapViewController: UIViewController {
    
    private let input = PassthroughSubject<CreateMapViewModel.Input, Never>()
    private let inputToParent = PassthroughSubject<CreateModeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    private var contentView = CreateMapView()
    
    var viewModel: CreateMapViewModel!
    var parentViewModel: CreateModeViewModel!
    
    override func loadView() {
        view = contentView
    }
    
    init(_ createModeViewModel: CreateModeViewModel, _ viewModel: CreateMapViewModel) {
        self.parentViewModel = createModeViewModel
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setUpTargets()
        setUpGestureRecognizer()
        setUpEditModeView()
        showContentView(isShown: true)
        self.contentView.scrollView.delegate = self
        self.contentView.nameInputView.nameTextField.delegate = self
    }
    
    private func setUpGestureRecognizer() {
        let addObjectTapGesture = UITapGestureRecognizer(target: self, action: #selector(addObjectByTap(_:)))
        self.contentView.scrollView.addGestureRecognizer(addObjectTapGesture)
        self.contentView.scrollView.isUserInteractionEnabled = true
        
        let hideKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap))
        contentView.nameInputView.addGestureRecognizer(hideKeyboardTapGesture)
    }
    
    private func setUpTargets() {
        contentView.bottomToolView.objectColorButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectShapeButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectSizeButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.topToolView.backButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.topToolView.saveButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.alertView.keepEditingButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.alertView.discardButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.nameInputView.backButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.nameInputView.saveButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    private func setUpEditModeView() {
        if viewModel.isEditing {
            viewModel.objectViewList.forEach {
                addObjectScrollView(with: $0)
            }
        }
    }
    
    private func bind(){
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .objectColorButtonDidTapOutput:
                    self?.contentView.bottomToolView.objectColorButton.setImage(UIImage(named: "\(self?.viewModel.objectColor ?? "")"), for: .normal)
                case .objectShapeButtonDidTapOutput:
                    self?.contentView.bottomToolView.objectShapeButton.setImage(UIImage(named: "\(self?.viewModel.objectShape ?? "")"), for: .normal)
                case .objectSizeButtonDidTapOutput:
                    self?.contentView.bottomToolView.objectSizeButton.setImage(UIImage(named: "\(self?.viewModel.objectSize ?? "")"), for: .normal)
                case .saveButtonDidTapOutput:
                    self?.navigationController?.popViewController(animated: false)
                }
            }.store(in: &subscriptions)
        
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        switch sender {
        case self.contentView.bottomToolView.objectColorButton:
            viewModel.updateObjectColor()
            input.send(.objectColorButtonDidTap)
        case self.contentView.bottomToolView.objectShapeButton:
            viewModel.updateObjectShape()
            input.send(.objectShapeButtonDidTap)
        case self.contentView.bottomToolView.objectSizeButton:
            viewModel.updateObjectSize()
            input.send(.objectSizeButtonDidTap)
        case self.contentView.topToolView.backButton:
            if viewModel.isChangedCreativeObjectList() {
                self.navigationController?.popViewController(animated: true)
            } else {
                showAlertView(isShown: true)
            }
        case self.contentView.topToolView.saveButton:
            if viewModel.isEditing {
                let capturingView = self.contentView
                capturingView.gridContainerView.isHidden = true
                if let capturedImage = capturingView.scrollView.screenshot(),
                   let imageData = capturedImage.pngData() {
                    let previewId = UUID().uuidString
                    UserDefaults.standard.set(imageData, forKey: previewId)
                    self.viewModel.previewId = previewId
                    input.send(.saveButtonDidTap)
                }
            } else {
                showNameInputView(isShown: true)
            }
        case self.contentView.alertView.keepEditingButton:
            showContentView(isShown: true)
        case self.contentView.alertView.discardButton:
            self.navigationController?.popViewController(animated: true)
        case self.contentView.nameInputView.backButton:
            contentView.nameInputView.nameTextField.resignFirstResponder()
            showContentView(isShown: true)
        case self.contentView.nameInputView.saveButton:
            if self.contentView.nameInputView.nameTextField.text?.count == 0 {
                viewModel.map?.titleLabel  = ""
            } else {
                viewModel.map?.titleLabel = self.contentView.nameInputView.nameTextField.text!
            }
            showContentView(isShown: true)
            let capturingView = self.contentView
            capturingView.gridContainerView.isHidden = true
            if let capturedImage = capturingView.scrollView.screenshot(),
               let imageData = capturedImage.pngData() {
                let previewId = UUID().uuidString
                UserDefaults.standard.set(imageData, forKey: previewId)
                self.viewModel.previewId = previewId
                input.send(.saveButtonDidTap)
            }
        default:
            fatalError()
        }
    }
    
    func configure(_ createModeViewModel: CreateModeViewModel, _ viewModel: CreateMapViewModel) {
        self.parentViewModel = createModeViewModel
        self.viewModel = viewModel
    }
    
    private func showContentView(isShown: Bool){
        if isShown {
            [contentView.topToolView, contentView.bottomToolView, contentView.scrollView].forEach {
                $0.isHidden = !isShown
            }
            [contentView.alertView, contentView.nameInputView].forEach {
                $0.isHidden = isShown
            }
        }
    }
    
    private func showAlertView(isShown: Bool){
        if isShown {
            [contentView.alertView].forEach {
                $0.isHidden = !isShown
            }
            [contentView.topToolView, contentView.bottomToolView, contentView.scrollView, contentView.nameInputView].forEach {
                $0.isHidden = isShown
            }
        }
    }
    
    private func showNameInputView(isShown: Bool){
        if isShown {
            [contentView.nameInputView].forEach {
                $0.isHidden = !isShown
            }
            [contentView.topToolView, contentView.bottomToolView, contentView.scrollView, contentView.alertView].forEach {
                $0.isHidden = isShown
            }
        }
    }
}

extension CreateMapViewController: UIScrollViewDelegate {
    
    @objc func addObjectByTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.contentView.scrollView)
        let offset = self.contentView.scrollView.contentOffset
        let tappedPoint = CGPoint(x: tapLocation.x + offset.x, y: tapLocation.y + offset.y)
        
        if viewModel.addObjectAtPoint(tappedPoint, tapLocation) {
            // viewModel.creativeObjectList가 nil이 아닌 경우에만 실행
            //            if let lastObject = viewModel.creativeObjectList.last {
            //                addObjectScrollView(with: lastObject.object)
            //                // MARK: CGPath 확인 [DEBUG]
            //                let lastObjectPath = lastObject.path
            //                contentView.scrollView.subviews.last?.addShapeLayer(to: lastObjectPath)
            //            }
            if let lastView = viewModel.objectViewList.last {
                addObjectScrollView(with: lastView)
            }
        }
    }
    
    func addObjectScrollView(with objectView: UIImageView) {
        self.contentView.scrollView.addSubview(objectView)
    }
    
}

extension UIView {
    func addShapeLayer(to path: CGPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        layer.addSublayer(shapeLayer)
    }
}

extension CreateMapViewController: UITextFieldDelegate {
    @objc private func hideKeyboardByTap() {
        if contentView.nameInputView.nameTextField.isFirstResponder {
            contentView.nameInputView.nameTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

fileprivate extension UIScrollView {
    func screenshot() -> UIImage? {
        let contentWidth = self.contentSize.width
        let contentHeight = self.contentSize.height
        let captureWidth = contentHeight * 2
        
        UIGraphicsBeginImageContext(CGSize(width: captureWidth, height: contentHeight))
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = CGPoint.zero
        self.layer.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
        
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        UIGraphicsEndImageContext()
        return image
    }
}

fileprivate extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
