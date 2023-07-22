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
        case objectColorButtonDidTap
        case objectShapeButtonDidTap
        case objectSizeButtonDidTap
        case saveButtonDidTap
    }
    enum Output {
        case objectColorButtonDidTapOutput
        case objectShapeButtonDidTapOutput
        case objectSizeButtonDidTapOutput
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
        CGSize(width: 75.0, height: 75.0),
        CGSize(width: 105.0, height: 105.0),
        CGSize(width: 150.0, height: 150.0),
    ]
    
    private let CGSizeList_Diamond: [CGSize] = [
        CGSize(width: 62.79, height: 90.0),
        CGSize(width: 87.91, height: 126.0),
        CGSize(width: 125.58, height: 180.0),
    ]

    private var objectColorIndex = 0
    private var objectSizeIndex = 0
    private var objectShapeIndex = 0
    
    // TODO: 나중에 주입받아야함 -> creativeObject
    var creativeObjectList: [CreativeObject] = []
    var temporaryCreativeObjectList: [CreativeObject] = []
    var previewId: String = ""
    
    var objectViewList: [UIImageView] = []
    var temporaryObjectViewList: [UIImageView] = []
    
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
        self.map = map ?? CreativeMapModel(titleLabel: "", lastEdited: Date(), objectList: [], previewId: previewId)
        self.creativeObjectList = map?.objectList ?? []
        self.temporaryCreativeObjectList = map?.objectList ?? []
        self.isEditing = isEditing ?? false
        self.indexPath = indexPath ?? IndexPath(row: 0, section: 1)
        self.objectViewList = map?.objectList.map { $0.object } ?? []
        self.temporaryObjectViewList = map?.objectList.map { $0.object } ?? []
    }
    
    // MARK: Functions
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .objectColorButtonDidTap:
                self?.output.send(.objectColorButtonDidTapOutput)
            case .objectShapeButtonDidTap:
                self?.output.send(.objectShapeButtonDidTapOutput)
            case .objectSizeButtonDidTap:
                self?.output.send(.objectSizeButtonDidTapOutput)
            case .saveButtonDidTap:
                self?.map = CreativeMapModel(titleLabel: (self?.map?.titleLabel)!, lastEdited: Date.now, objectList: (self?.creativeObjectList)!, previewId: (self?.previewId)!)
                if let map = self?.map {
                    self?.creativeMapSubject.send((map, self?.isEditing ?? false, self?.indexPath ?? IndexPath()))
                }
                self?.output.send(.saveButtonDidTapOutput)
            }
        }.store(in: &subscriptions)
        return output.eraseToAnyPublisher()

    }
    
    // MARK: Tap한 영역에 이미 해당 creativeObjectList의 element가 있는지 여부 확인
    func isOverlapWithOtherObjects(_ point: CGPoint, objectSize: CGSize) -> UIImageView? {
        for objectView in objectViewList {
            let objectFrame = objectView.frame
            if objectFrame.intersects(CGRect(origin: point, size: objectSize)) {
                return objectView
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
        
            let pathIndex = getPathIndex(size: objectSize, shapeIndex: objectShapeIndex)
            
            // MARK: 1. creativeObject 생성
            let creativeObject = createCreativeObject(
                point: tapCenterPoint,
                color: self.objectColor,
                size: self.objectSize,
                shape: self.objectShape,
                // MARK: X1.5배
                pathIndex: pathIndex,
                rect: CGRect(origin: tapCenterPoint, size: objectSize),
                colorIndex: objectColorIndex,
                sizeIndex: objectSizeIndex,
                shapeIndex: objectShapeIndex
            )
            
            // MARK: 2. 생성한 creativeObject 추가
            creativeObjectList.append(creativeObject)
            objectViewList.append(objectView)
            return true
        }
    }
    
    // MARK: 겹쳐진 creativeObject를 creativeObjectList에서 찾아서 제거
    func removeObjectView(_ objectView: UIImageView) {
        if let index = objectViewList.firstIndex(where: { $0 == objectView }) {
            
            // MARK: 저장용 creativeObjectList에서 삭제, edit 전용 objectViewList에서 삭제
            // MARK: 이렇게 하는 이유는 CreativeObject.object는 연산 프로퍼티이기 때문에 실제 scrollView의 object가 서로 다른 객체이기 때문.
            creativeObjectList.remove(at: index)
            objectViewList.remove(at: index)
            
            objectView.removeFromSuperview()
        }
    }
    
    func updateObjectColor() {
        objectColorIndex = (objectColorIndex + 1) % objectColorList.count
    }
    
    func updateObjectShape() {
        objectShapeIndex = (objectShapeIndex + 1) % objectShapeList.count
    }
    
    func updateObjectSize() {
        objectSizeIndex = (objectSizeIndex + 1) % objectSizeList.count
    }
    
    private func createCreativeObject(point: CGPoint, color: String, size: String, shape: String, pathIndex: Int, rect: CGRect, colorIndex: Int, sizeIndex: Int, shapeIndex: Int) -> CreativeObject {
        let creativeObject = CreativeObject(point: point, color: color, size: size, shape: shape, pathIndex: pathIndex, rect: rect, colorIndex: colorIndex, sizeIndex: sizeIndex, shapeIndex: shapeIndex)
        return creativeObject
    }
    
    func isChangedCreativeObjectList() -> Bool {
        return creativeObjectList == temporaryCreativeObjectList
    }
    
    func getPathIndex(size: CGSize, shapeIndex: Int) -> Int {
        switch size {
        case CGSizeList[0]:
            switch shapeIndex {
            case 0:
                return 0
            case 1:
                return 3
            case 2:
                return 6
            default:
                fatalError()
            }
        case CGSizeList[1]:
            switch shapeIndex {
            case 0:
                return 1
            case 1:
                return 4
            case 2:
                return 7
            default:
                fatalError()
            }
        case CGSizeList[2]:
            switch shapeIndex {
            case 0:
                return 2
            case 1:
                return 5
            case 2:
                return 8
            default:
                fatalError()
            }
        case CGSizeList_Diamond[0]:
            return 9
        case CGSizeList_Diamond[1]:
            return 10
        case CGSizeList_Diamond[2]:
            return 11
        default:
            fatalError()
        }
    }
}
