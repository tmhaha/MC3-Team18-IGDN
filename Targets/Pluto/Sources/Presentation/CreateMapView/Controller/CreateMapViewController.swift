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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CreateMapViewModel()
        bind()
        setUpTargets()
        setUpGestureRecognizer()
        
        self.contentView.scrollView.delegate = self
    }
    
    private func setUpGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.contentView.scrollView.addGestureRecognizer(tapGesture)
        self.contentView.scrollView.isUserInteractionEnabled = true
    }
    
    private func setUpTargets() {
        contentView.bottomToolView.objectUpButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectDownButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectColorUpButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectColorDownButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectSizeUpButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.bottomToolView.objectSizeDownButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.topToolView.backButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.topToolView.saveButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    private func bind(){
        
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .objectUpButtonDidTapOutput:
                    print(">>> receive: objectUpButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectView.backgroundColor = self?.viewModel.object
                case .objectDownButtonDidTapOutput:
                    print(">>> receive: objectDownButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectView.backgroundColor = self?.viewModel.object
                case .objectSizeUpButtonDidTapOutput:
                    print(">>> receive: objectSizeUpButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectSizeView.backgroundColor = self?.viewModel.objectSize
                case .objectSizeDownButtonDidTapOutput:
                    print(">>> receive: objectSizeDownButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectSizeView.backgroundColor = self?.viewModel.objectSize
                case .objectColorUpButtonDidTapOutput:
                    print(">>> receive: objectColorUpButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectColorView.backgroundColor = self?.viewModel.objectColor
                case .objectColorDownButtonDidTapOutput:
                    print(">>> receive: objectColorDownButtonDidTapOutput")
                    self?.contentView.bottomToolView.objectColorView.backgroundColor = self?.viewModel.objectColor
                }
            }.store(in: &subscriptions)
        
        let outputToParent = parentViewModel.transform(input: inputToParent.eraseToAnyPublisher())
        outputToParent.receive(on: RunLoop.main)
            .sink { [weak self] event in
                if event == .saveMap {
                    print("saveMap")
                }
            }.store(in: &subscriptions)
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        switch sender {
        case self.contentView.bottomToolView.objectUpButton:
            viewModel.updateObject(isIncrease: true)
            input.send(.objectUpButtonDidTap)
        case self.contentView.bottomToolView.objectDownButton:
            viewModel.updateObject(isIncrease: false)
            input.send(.objectDownButtonDidTap)
        case self.contentView.bottomToolView.objectSizeUpButton:
            viewModel.updateObjectSize(isIncrease: true)
            input.send(.objectSizeUpButtonDidTap)
        case self.contentView.bottomToolView.objectSizeDownButton:
            viewModel.updateObjectSize(isIncrease: false)
            input.send(.objectSizeDownButtonDidTap)
        case self.contentView.bottomToolView.objectColorUpButton:
            viewModel.updateObjectColor(isIncrease: true)
            input.send(.objectColorUpButtonDidTap)
        case self.contentView.bottomToolView.objectColorDownButton:
            viewModel.updateObjectColor(isIncrease: false)
            input.send(.objectColorDownButtonDidTap)
        case self.contentView.topToolView.backButton:
            self.navigationController?.popViewController(animated: true)
        case self.contentView.topToolView.saveButton:
            inputToParent.send(.saveButtonDidTap)
            print("saveButton Did Tap")
        default:
            fatalError()
        }
    }
    
    func configure(with createModeViewModel: CreateModeViewModel) {
        self.parentViewModel = createModeViewModel
    }

}

extension CreateMapViewController: UIScrollViewDelegate {
    // UITapGestureRecognizer의 액션 메서드
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        var tapLocation = sender.location(in: self.contentView.scrollView)
        let offset = self.contentView.scrollView.contentOffset
        let tappedPoint = CGPoint(x: tapLocation.x + offset.x, y: tapLocation.y + offset.y)
        if viewModel.addObjectAtPoint(tappedPoint, tapLocation) {
            addObjectScrollView(with: viewModel.objectViews.last!)
        }
    }
    
    func addObjectScrollView(with objectView: UIView) {
        self.contentView.scrollView.addSubview(objectView)
//        if viewModel.objectViews.last === contentView.scrollView.subviews.last {
//            print("true")
//        }
    }

}
