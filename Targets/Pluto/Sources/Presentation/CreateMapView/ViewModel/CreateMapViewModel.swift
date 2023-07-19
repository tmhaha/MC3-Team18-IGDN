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
    public let creativeMapSubject = PassthroughSubject<(CreativeMapModel, Bool, IndexPath), Never>()
    
    
    public var mapName: String!
    public var map: CreativeMapModel?
    private let output = PassthroughSubject<Output, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    private let objectImageList: [[[String]]] = Obstacle.image
    
    private let objectColorList: [String] = Obstacle.color
    private let objectSizeList: [String] = Obstacle.size
    private let objectShapeList: [String] = Obstacle.shape
    
    private let CGSizeList: [CGSize] = [
        CGSize(width: 50.0, height: 50.0),
        CGSize(width: 70.0, height: 70.0),
        CGSize(width: 100.0, height: 100.0),
    ]
    
    private let CGSizeList_Diamond: [CGSize] = [
        CGSize(width: 41.86, height: 60.0),
        CGSize(width: 58.6, height: 84.0),
        CGSize(width: 83.72, height: 120.0),
    ]

    private var objectColorIndex = 0
    private var objectSizeIndex = 0
    private var objectShapeIndex = 0
    
    // TODO: 나중에 주입받아야함 -> creativeObject
    var creativeObjectList: [CreativeObject]?
    var temporaryCreativeObjectList: [CreativeObject]?
    var isEditing: Bool = false
    var indexPath: IndexPath?
    
    var objectColor: String {
        return objectColorList[objectColorIndex]
    }
    var objectSize: String {
        return objectSizeList[objectSizeIndex]
    }
    var objectShape: String {
        return objectShapeList[objectShapeIndex]
    }
    
    init(map: CreativeMapModel? = nil, isEditing: Bool? = nil, indexPath: IndexPath? = nil) {
        self.map = map ?? CreativeMapModel(titleLabel: "", lastEdited: Date(), objectList: [])
        self.creativeObjectList = map?.objectList ?? []
        self.temporaryCreativeObjectList = map?.objectList ?? []
        self.isEditing = isEditing ?? false
        self.indexPath = indexPath ?? IndexPath(row: 0, section: 1)
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
                self?.map = CreativeMapModel(titleLabel: (self?.map?.titleLabel)!, lastEdited: Date.now, objectList: (self?.creativeObjectList!)!)
                if let map = self?.map {
                    self?.creativeMapSubject.send((map, self?.isEditing ?? false, self?.indexPath ?? IndexPath()))
                }
                self?.output.send(.saveButtonDidTapOutput)
            }
        }.store(in: &subscriptions)
        return output.eraseToAnyPublisher()

    }
    
    // MARK: Tap한 영역에 이미 해당 creativeObjectList의 element가 있는지 여부 확인
    func isOverlapWithOtherObjects(_ point: CGPoint, objectSize: CGSize) -> UIView? {
        if let creativeObjectList {
            for objectView in creativeObjectList {
                let objectFrame = objectView.object.frame
                if objectFrame.intersects(CGRect(origin: point, size: objectSize)) {
                    return objectView.object
                }
            }
        }
        return nil
    }
    
    func addObjectAtPoint(_ point: CGPoint, _ tapLocation: CGPoint) -> Bool {
        var objectSize: CGSize
        if objectShapeIndex == 3 {
            objectSize = CGSizeList_Diamond[objectSizeIndex]
        } else {
            objectSize = CGSizeList[objectSizeIndex]
        }

        let tapCenterPoint = CGPoint(x: tapLocation.x - objectSize.width/2, y: tapLocation.y - objectSize.height/2)
        
        // MARK: 해당 위치에 겹치는 오브젝트가 있는지 확인
        if let overlappingObjectView = isOverlapWithOtherObjects(tapCenterPoint, objectSize: objectSize) {
            // MARK: 겹치는 오브젝트 제거
            removeObjectView(overlappingObjectView)
            overlappingObjectView.removeFromSuperview()
            return false
        } else {
            let objectView = UIImageView(frame: CGRect(origin: tapCenterPoint, size: objectSize))
            objectView.backgroundColor = .clear
            objectView.image = UIImage(named: "\(objectImageList[objectColorIndex][objectSizeIndex][objectShapeIndex])")
            
            
            // MARK: 1. creativeObject 생성
            let creativeObject = createCreativeObject(
                point: tapCenterPoint,
                color: self.objectColor,
                size: self.objectSize,
                shape: self.objectShape,
                path: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath,
                object: objectView
            )
            
            // MARK: 2. 생성한 creativeObject 추가
            creativeObjectList?.append(creativeObject)
            return true
        }
    }
    
    // MARK: 겹쳐진 creativeObject를 creativeObjectList에서 찾아서 제거
    func removeObjectView(_ objectView: UIView) {
        if let index = creativeObjectList?.firstIndex(where: { $0.object === objectView }) {
            creativeObjectList?.remove(at: index)
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
            objectShapeIndex = (objectShapeIndex + 1) % objectShapeList.count
        } else {
            objectShapeIndex = (objectShapeIndex - 1 + objectShapeList.count) % objectShapeList.count
        }
    }
    
    private func createCreativeObject(point: CGPoint, color: String, size: String, shape: String, path: CGPath, object: UIView) -> CreativeObject {
        let creativeObject = CreativeObject(point: point, color: color, size: size, shape: shape, path: path, object: object)
        return creativeObject
    }
    
    func isChangedCreativeObjectList() -> Bool {
        return creativeObjectList == temporaryCreativeObjectList
    }
}
