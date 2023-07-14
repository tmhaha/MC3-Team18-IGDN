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
    
    // MARK: Input, Output
    enum Input {
        case objectUpButtonDidTap
        case objectDownButtonDidTap
        case objectSizeUpButtonDidTap
        case objectSizeDownButtonDidTap
        case objectColorUpButtonDidTap
        case objectColorDownButtonDidTap
    }
    enum Output {
        case objectUpButtonDidTapOutput
        case objectDownButtonDidTapOutput
        case objectSizeUpButtonDidTapOutput
        case objectSizeDownButtonDidTapOutput
        case objectColorUpButtonDidTapOutput
        case objectColorDownButtonDidTapOutput
    }
    
    // MARK: Properties
    let objectWidth = 50.0
    let objectHeight = 50.0
    var objectViews: [UIView] = []
    
    private var objectColorIndex = 0
    private var objectSizeIndex = 0
    private var objectIndex = 0
    
    private let objectColorList: [UIColor] = [
        UIColor(hex: 0xFF3434).withAlphaComponent(0.41),
        UIColor(hex: 0x2244FF).withAlphaComponent(0.41),
        UIColor(hex: 0x4061F8).withAlphaComponent(0.41),
    ]
    
    private let objectSizeList: [UIColor] = [
        UIColor(hex: 0xFF3434).withAlphaComponent(0.41),
        UIColor(hex: 0x2244FF).withAlphaComponent(0.41),
        UIColor(hex: 0x4061F8).withAlphaComponent(0.41),
    ]
    
    private let objectList: [UIColor] = [
        UIColor(hex: 0xFF3434).withAlphaComponent(0.41),
        UIColor(hex: 0x2244FF).withAlphaComponent(0.41),
        UIColor(hex: 0x4061F8).withAlphaComponent(0.41),
    ]
    
    // View에 표시할 데이터
    var objectColor: UIColor {
        return objectColorList[objectColorIndex]
    }
    
    var objectSize: UIColor {
        return objectSizeList[objectSizeIndex]
    }
    
    var object: UIColor {
        return objectList[objectIndex]
    }
    
    private let output = PassthroughSubject<Output, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    
    // MARK: Functions
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .objectUpButtonDidTap:
                print(">>> objectUpButton Did Tap")
                self?.output.send(.objectUpButtonDidTapOutput)
            case .objectDownButtonDidTap:
                print(">>> objectDownButton Did Tap")
                self?.output.send(.objectDownButtonDidTapOutput)
            case .objectSizeUpButtonDidTap:
                print(">>> objectSizeUpButton Did Tap")
                self?.output.send(.objectSizeUpButtonDidTapOutput)
            case .objectSizeDownButtonDidTap:
                print(">>> objectSizeDownButton Did Tap")
                self?.output.send(.objectSizeDownButtonDidTapOutput)
            case .objectColorUpButtonDidTap:
                print(">>> objectColorUpButton Did Tap")
                self?.output.send(.objectColorUpButtonDidTapOutput)
            case .objectColorDownButtonDidTap:
                print(">>> objectColorDownButton Did Tap")
                self?.output.send(.objectColorDownButtonDidTapOutput)
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
    
    func updateObjectColor(isIncrease: Bool) {
        if isIncrease {
            objectColorIndex = (objectColorIndex + 1) % objectColorList.count
        } else {
            objectColorIndex = (objectColorIndex - 1 + objectColorList.count) % objectColorList.count
        }
    }
    
    func updateObjectSize(isIncrease: Bool) {
        if isIncrease {
            objectSizeIndex = (objectSizeIndex + 1) % objectSizeList.count
        } else {
            objectSizeIndex = (objectSizeIndex - 1 + objectSizeList.count) % objectSizeList.count
        }
    }
    
    func updateObject(isIncrease: Bool) {
        if isIncrease {
            objectIndex = (objectIndex + 1) % objectList.count
        } else {
            objectIndex = (objectIndex - 1 + objectList.count) % objectList.count
        }
    }
    
}
