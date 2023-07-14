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

    private var contentView = CreateMapView()
    var viewModel: CreateMapViewModel!
    var parentViewModel: CreateModeViewModel!
    private let input = PassthroughSubject<CreateMapViewModel.Input, Never>()
    private let inputToParent = PassthroughSubject<CreateModeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
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
                    // TODO: 버튼1로 인한 UI 또는 상태 변경
                    print(">>> receive: objectUpButtonDidTapOutput")
                case .objectDownButtonDidTapOutput:
                    // TODO: 버튼2로 인한 UI 또는 상태 변경
                    print(">>> receive: objectDownButtonDidTapOutput")
                case .objectSizeUpButtonDidTapOutput:
                    print(">>> receive: objectSizeUpButtonDidTapOutput")
                case .objectSizeDownButtonDidTapOutput:
                    print(">>> receive: objectSizeDownButtonDidTapOutput")
                case .objectColorUpButtonDidTapOutput:
                    print(">>> receive: objectColorUpButtonDidTapOutput")
                case .objectColorDownButtonDidTapOutput:
                    print(">>> receive: objectColorDownButtonDidTapOutput")
                }
            }
            .store(in: &subscriptions)
        
        let outputToParent = parentViewModel.transform(input: inputToParent.eraseToAnyPublisher())
        outputToParent.receive(on: RunLoop.main)
            .sink { [weak self] event in
                if event == .saveMap {
                    print("saveMap")
                }
            }
    }
    
    


    
    @objc private func buttonDidTap(_ sender: UIButton) {
        switch sender {
        case self.contentView.bottomToolView.objectUpButton:
            input.send(.objectUpButtonDidTap)
        case self.contentView.bottomToolView.objectDownButton:
            input.send(.objectDownButtonDidTap)
        case self.contentView.bottomToolView.objectSizeUpButton:
            input.send(.objectSizeUpButtonDidTap)
        case self.contentView.bottomToolView.objectSizeDownButton:
            input.send(.objectSizeDownButtonDidTap)
        case self.contentView.bottomToolView.objectColorUpButton:
            input.send(.objectColorUpButtonDidTap)
        case self.contentView.bottomToolView.objectColorDownButton:
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
        print("Tapped Point: \(tappedPoint)")
        
        let objectSize = CGSize(width: viewModel.objectWidth, height: viewModel.objectHeight)
        tapLocation.x = tapLocation.x - viewModel.objectWidth/2
        tapLocation.y = tapLocation.y - viewModel.objectHeight/2
        
        // 해당 위치에 겹치지 않는지 확인하고 오브젝트를 추가
        if !viewModel.isOverlapWithOtherObjects(tapLocation, objectSize: objectSize) {
            viewModel.addObjectAtPoint(tapLocation, objectSize: objectSize)
            addObjectAtPoint(tapLocation, objectSize: objectSize)
        }
    }
    
    func addObjectAtPoint(_ point: CGPoint, objectSize: CGSize) {
        let objectView = UIView(frame: CGRect(origin: point, size: objectSize))
        objectView.backgroundColor = UIColor.yellow
        self.contentView.scrollView.addSubview(objectView)
        
    }

}
