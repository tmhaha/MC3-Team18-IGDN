//
//  CreateMapViewModel.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/11.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import Combine

final class CreateMapViewModel {
    
    let objectWidth = 50.0
    let objectHeight = 50.0
    var objectViews: [UIView] = []
    
    enum Input {
        case buttonOneDidTap
        case buttonTwoDidTap
    }
    enum Output {
        case buttonOneDidTapOutput
        case buttonTwoDidTapOutput
    }
    
    private let output = PassthroughSubject<Output, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .buttonOneDidTap:
                print(">>> Button One Did Tap")
                self?.output.send(.buttonOneDidTapOutput)
            case .buttonTwoDidTap:
                print(">>> Button Two Did Tap")
                self?.output.send(.buttonTwoDidTapOutput)
            }
        }.store(in: &subscriptions)
        return output.eraseToAnyPublisher()
    }
    
    func isOverlapWithOtherObjects(_ point: CGPoint, objectSize: CGSize) -> Bool {
        for objectView in objectViews {
            let objectFrame = objectView.frame
            if objectFrame.intersects(CGRect(origin: point, size: objectSize)) {
                return true
            }
        }
        return false
    }
    
    func addObjectAtPoint(_ point: CGPoint, objectSize: CGSize) {
        let objectView = UIView(frame: CGRect(origin: point, size: objectSize))
        objectView.backgroundColor = UIColor.yellow
        objectViews.append(objectView)
    }
}
