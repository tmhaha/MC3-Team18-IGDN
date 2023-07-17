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
        case playButtonDidTapOutput
        case editButtonDidTapOutput(IndexPath: IndexPath)
//        case editTitleButtonDidTapOutput(IndexPath: IndexPath)
    }
    
    private let output = PassthroughSubject<Output, Never>()
    private var subscriptions = Set<AnyCancellable>()
    let createMapViewModel: CreateMapViewModel!
    var mapList: [CreativeMapModel] = []
    var objectList: [CreativeObject] = []
    
    init(creativeMapViewModel: CreateMapViewModel) {
        self.createMapViewModel = creativeMapViewModel
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .selectButtonDidTap(let indexPath): // TODO: TestCode임 추후 삭제 (선택한 뷰의 데이터를 삭제)(DEBUG용)
                self?.mapList.remove(at: indexPath.row)
                self?.output.send(.presentSelectMapView)
            case .createMapButtonDidTap:
                // TODO: 비즈니스 로직
                self?.output.send(.presentCreateMapView)
            case .playButtonDidTap(let indexPath):
                print("'''VM에서의 playButton으로 인한 비즈니스 로직'''") // MARK: DEBUG
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 게임화면으로 연결
                self?.output.send(.playButtonDidTapOutput)
                print(">>> \(indexPath.row)번째 Cell의 playButton")// MARK: DEBUG
            case .editButtonDidTap(let indexPath):
                print("'''VM에서의 editButton으로 인한 비즈니스 로직'''")// MARK: DEBUG
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 뷰로 연결
                print(">>> \(indexPath.row)번째 Cell의 editButton")// MARK: DEBUG
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
                    print("indexPath: \(indexPath)")
                }
                // MARK: isEditing이 false
                // creativeObjectList를 처리하는 로직을 작성합니다
                else {
                    self?.appendMap(with: map)
                }
            }.store(in: &subscriptions)
        
    }
    
    private func appendMap(with object: CreativeMapModel) {
        mapList.append(CreativeMapModel(titleLabel: object.titleLabel, lastEdited: object.lastEdited, objectList: object.objectList))
        // MARK: 추가한 Object들 출력예시 (DEBUG)
        mapList.forEach{  maps in
            maps.objectList.forEach { object in
                print(object.shape)
            }
            print("===")
        }
        objectList.removeAll()
        output.send(.reload)
    }
    
    private func updateMap(with object: CreativeMapModel, indexPath: IndexPath) {
        self.mapList[indexPath.row] = CreativeMapModel(titleLabel: self.mapList[indexPath.row].titleLabel, lastEdited: object.lastEdited, objectList: object.objectList)
        // MARK: 추가한 Object들 출력예시 (DEBUG)
        mapList.forEach{  maps in
            maps.objectList.forEach { object in
                print(object.shape)
            }
            print("===")
        }
        objectList.removeAll()
        output.send(.reload)
    }
    
    
}
