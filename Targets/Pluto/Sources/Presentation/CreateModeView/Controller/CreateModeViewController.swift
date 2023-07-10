//
//  CreateModeViewController.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import Combine

class CreateModeViewController: UIViewController {

    private lazy var contentView = CreateModeView()
    var viewModel: CreateModeViewModel!
    private let input = PassthroughSubject<CreateModeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel = CreateModeViewModel()
        setUpTargets()
        bind()
    }
    
    private func setUpTargets() {
        contentView.selectMapButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        contentView.createMapButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    private func bind(){
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .presentCreateMapView:
                    // TODO: 화면 전환
                    print(">>> receive: presentCreateMapView")
                case .presentSelectMapView:
                    // TODO: 화면 전환
                    print(">>> receive: presentSelectMapView")
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        switch sender {
        case self.contentView.createMapButton:
            input.send(.createMapButtonDidTap)
        case self.contentView.selectMapButton:
            input.send(.selectButtonDidTap)
        default:
            fatalError()
        }
    }

}
