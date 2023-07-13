//
//  CreateModeViewModel.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import Combine


final class CreateModeViewModel {
    enum Input {
        case selectButtonDidTap
        case createMapButtonDidTap
        case saveButtonDidTap
    }

    enum Output {
        case presentSelectMapView
        case presentCreateMapView
        case saveMap
    }

    private let output = PassthroughSubject<Output, Never>()
    private var subscriptions = Set<AnyCancellable>()
    var mapList: [CreativeMapModel] = []
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectButtonDidTap:
                // TODO: 비즈니스 로직
                print(">>> selectButton DidTap in transform")
                self?.mapList.removeFirst()
                self?.output.send(.presentSelectMapView)
            case .createMapButtonDidTap:
                // TODO: 비즈니스 로직
                print(">>> createMapButton DidTap in transform")
                self?.output.send(.presentCreateMapView)
            case .saveButtonDidTap:
                print(">>> saveButtonDidTap DidTap in transform")
                self?.mapList.append(CreativeMapModel(titleLabel: "Test"))
                self?.output.send(.saveMap)
            }
        }
        .store(in: &subscriptions)
        return output.eraseToAnyPublisher()
    }
    
}
