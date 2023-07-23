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
        case selectButtonDidTap(indexPath: IndexPath) // TODO: TestCode임 추후 삭제(DEBUG용)
        case createMapButtonDidTap
        case playButtonDidTap(indexPath: IndexPath)
        case editButtonDidTap(indexPath: IndexPath)
//        case editTitleButtonDidTap(indexPath: IndexPath)
    }
    
    enum Output {
        case presentSelectMapView
        case presentCreateMapView
        case reload
        case playButtonDidTapOutput(objects: [Object])
        case editButtonDidTapOutput(IndexPath: IndexPath)
//        case editTitleButtonDidTapOutput(IndexPath: IndexPath)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var subscriptions = Set<AnyCancellable>()

    var mapList: [CreativeMapModel]
    var objectList: [CreativeObject] = []
    var transferingObjects: [Object] = []
    init(mapList: [CreativeMapModel]? = nil) {
        self.mapList = mapList ?? []
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectButtonDidTap(let indexPath): // TODO: TestCode임 추후 삭제 (선택한 뷰의 데이터를 삭제)(DEBUG용)
                self?.mapList.remove(at: indexPath.row)
                if let mapList = self?.mapList {
                    UserDefaultsManager.saveCreativeMapsToUserDefaults(mapList)
                }
                self?.output.send(.presentSelectMapView)
            case .createMapButtonDidTap:
                // TODO: 비즈니스 로직
                self?.output.send(.presentCreateMapView)
            case .playButtonDidTap(let indexPath):
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 게임화면으로 연결
                if let objects = self?.mapList[indexPath.row].objectList {
                    if let transferObjects = self?.convertToObject(with: objects) {
                        self?.output.send(.playButtonDidTapOutput(objects: transferObjects))
                    }
                }
                print(">>> \(indexPath.row)번째 Cell의 playButton DidTap")// MARK: DEBUG
            case .editButtonDidTap(let indexPath):
                print("'''VM에서의 editButton으로 인한 비즈니스 로직'''")// MARK: DEBUG
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 뷰로 연결
                print(">>> \(indexPath.row)번째 Cell의 editButton DidTap")// MARK: DEBUG
                self?.output.send(.editButtonDidTapOutput(IndexPath: indexPath))
//            case .editTitleButtonDidTap(let indexPath):
//                print("'''VM에서의 editTitleButton으로 인한 비즈니스 로직'''")// MARK: DEBUG
//                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> title 변경
//                print(">>> \(indexPath.row)번째 Cell의 editTitleButton")// MARK: DEBUG
//                self?.output.send(.editTitleButtonDidTapOutput(IndexPath: indexPath))
            }
        }.store(in: &subscriptions)

        return output.eraseToAnyPublisher()
    }
    
    func bind(with viewModel: CreateMapViewModel) {
        viewModel.creativeMapSubject
            .sink { [weak self] creativeObjectList in
                let (map, isEditng, indexPath) = creativeObjectList
                self?.objectList = map.objectList
                
                // MARK: isEditing이 true
                if isEditng {
                    self?.updateMap(with: map, indexPath: indexPath)
                }
                // MARK: isEditing이 false
                // creativeObjectList를 처리하는 로직을 작성합니다
                else {
                    self?.appendMap(with: map)
                }
                if let mapList = self?.mapList {
                    UserDefaultsManager.saveCreativeMapsToUserDefaults(mapList)
                }
                self?.output.send(.reload)
            }.store(in: &subscriptions)
        
    }
    
    private func appendMap(with map: CreativeMapModel) {
        var newMap = map
        if newMap.titleLabel.count == 0 {
            newMap.titleLabel = "Slot \(mapList.count + 1)"
        }
        mapList.append(newMap)
        objectList.removeAll()
    }
    
    private func updateMap(with map: CreativeMapModel, indexPath: IndexPath) {
        self.mapList[indexPath.row] = CreativeMapModel(titleLabel: self.mapList[indexPath.row].titleLabel, lastEdited: map.lastEdited, objectList: map.objectList, previewId: map.previewId)
        objectList.removeAll()
    }

    private func convertToObject(with creativeObjectList: [CreativeObject]) -> [Object]{
        var objects: [Object] = []
        for object in creativeObjectList {
            let transferingObject = Object(creativeObject: object)
            objects.append(transferingObject)
        }
        return objects
    }
}
