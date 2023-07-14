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
        case saveButtonDidTap
    }
    enum Output {
        case objectUpButtonDidTapOutput
        case objectDownButtonDidTapOutput
        case objectSizeUpButtonDidTapOutput
        case objectSizeDownButtonDidTapOutput
        case objectColorUpButtonDidTapOutput
        case objectColorDownButtonDidTapOutput
        case saveButtonDidTapOutput
    }
    
    // MARK: Properties
    public let creativeObjectListSubject = PassthroughSubject<[CreativeObject], Never>()
    private let output = PassthroughSubject<Output, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    private let objectColorList: [UIColor] = [
        UIColor(hex: 0xFF3434),
        UIColor(hex: 0xF7CF51),
        UIColor(hex: 0x51AC65),
    ]
    
    private let objectSizeList: [UIColor] = [
        UIColor(hex: 0xFF3434),
        UIColor(hex: 0xF7CF51),
        UIColor(hex: 0x51AC65),
    ]
    
    private let objectList: [UIColor] = [
        UIColor(hex: 0xFF3434),
        UIColor(hex: 0xF7CF51),
        UIColor(hex: 0x51AC65),
    ]
    
    private var objectColorIndex = 0
    private var objectSizeIndex = 0
    private var objectIndex = 0
    
    let objectWidth = 50.0
    let objectHeight = 50.0
    var objectViews: [UIView] = []
    
    // TODO: 나중에 주입받아야함 -> creativeObject
    var creativeObjectList: [CreativeObject] = []
    
    var objectColor: UIColor {
        return objectColorList[objectColorIndex]
    }
    var objectSize: UIColor {
        return objectSizeList[objectSizeIndex]
    }
    var object: UIColor {
        return objectList[objectIndex]
    }
    
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
            case .saveButtonDidTap:
                print(">>> saveButton Did Tap")
                self?.creativeObjectListSubject.send(self?.creativeObjectList ?? [])
                self?.output.send(.saveButtonDidTapOutput)
            }
        }.store(in: &subscriptions)
        return output.eraseToAnyPublisher()

    }
    
    // MARK: Tap한 영역에 이미 해당 creativeObjectList의 element가 있는지 여부 확인
    func isOverlapWithOtherObjects(_ point: CGPoint, objectSize: CGSize) -> UIView? {
        for objectView in creativeObjectList {
            let objectFrame = objectView.object.frame
            if objectFrame.intersects(CGRect(origin: point, size: objectSize)) {
                return objectView.object
            }
        }
        return nil
    }
    
    func addObjectAtPoint(_ point: CGPoint, _ tapLocation: CGPoint) -> Bool {
        let objectSize = CGSize(width: objectWidth, height: objectHeight)
        let tapCenterPoint = CGPoint(x: tapLocation.x - objectWidth/2, y: tapLocation.y - objectHeight/2)
        
        // MARK: 해당 위치에 겹치는 오브젝트가 있는지 확인
        if let overlappingObjectView = isOverlapWithOtherObjects(tapCenterPoint, objectSize: objectSize) {
            // MARK: 겹치는 오브젝트 제거
            removeObjectView(overlappingObjectView)
            overlappingObjectView.removeFromSuperview()
            return false
        } else {
            let objectView = UIView(frame: CGRect(origin: tapCenterPoint, size: objectSize))
            objectView.backgroundColor = objectColor
            objectView.layer.borderColor = UIColor.gray.cgColor
            objectView.layer.borderWidth = 1
            
            // MARK: 1. creativeObject 생성
            let creativeObject = createCreativeObject(
                point: tapCenterPoint,
                color: objectColor,
                size: "\(objectSizeIndex)",
                shape: "\(objectIndex)",
                path: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath,
                object: objectView
            )
            
            // MARK: 2. 생성한 creativeObject 추가
            creativeObjectList.append(creativeObject)
            return true
        }
    }
    
    // MARK: 겹쳐진 creativeObject를 creativeObjectList에서 찾아서 제거
    func removeObjectView(_ objectView: UIView) {
        if let index = creativeObjectList.firstIndex(where: { $0.object === objectView }) {
            creativeObjectList.remove(at: index)
            objectView.removeFromSuperview()
        }
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
    
    private func createCreativeObject(point: CGPoint, color: UIColor, size: String, shape: String, path: CGPath, object: UIView) -> CreativeObject {
        let creativeObject = CreativeObject(point: point, color: color, size: size, shape: shape, path: path, object: object)
        return creativeObject
    }
}
