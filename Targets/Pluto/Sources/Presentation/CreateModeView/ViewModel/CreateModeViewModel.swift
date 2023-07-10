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
    }

    enum Output {
        case presentSelectMapView
        case presentCreateMapView
    }

    private let output = PassthroughSubject<Output, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectButtonDidTap:
                self?.output.send(.presentSelectMapView)
                // TODO: 비즈니스 로직
                print(">>> selectButton DidTap in transform")
            case .createMapButtonDidTap:
                self?.output.send(.presentCreateMapView)
                // TODO: 비즈니스 로직
                print(">>> createMapButton DidTap in transform")
            }
        }
        .store(in: &subscriptions)
        return output.eraseToAnyPublisher()
    }
    
}
