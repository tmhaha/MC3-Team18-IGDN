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
        case playButtonDidTap
        case editButtonDidTap
        case editTitleButtonDidTap
    }
    
    enum Output {
        case presentSelectMapView
        case presentCreateMapView
        case reload
        case playButtonDidTapOutput
        case editButtonDidTapOutput
        case editTitleButtonDidTapOutput
    }
    
    let createMapViewModel: CreateMapViewModel!
    private let output = PassthroughSubject<Output, Never>()
    private var subscriptions = Set<AnyCancellable>()
    var mapList: [CreativeMapModel] = []
    var objectList: [CreativeObject] = []
    
    init(creativeMapViewModel: CreateMapViewModel) {
        self.createMapViewModel = creativeMapViewModel
    }
    
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
            case .playButtonDidTap:
                print("'''VM에서의 playButton으로 인한 비즈니스 로직'''")
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 게임화면으로 연결
                self?.output.send(.playButtonDidTapOutput)
            case .editButtonDidTap:
                print("'''VM에서의 editButton으로 인한 비즈니스 로직'''")
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 뷰로 연결
                self?.output.send(.editButtonDidTapOutput)
            case .editTitleButtonDidTap:
                print("'''VM에서의 editTitleButton으로 인한 비즈니스 로직'''")
                // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> title 변경
                self?.output.send(.editTitleButtonDidTapOutput)
            }
        }.store(in: &subscriptions)

        return output.eraseToAnyPublisher()
    }
    
    func bind(with viewModel: CreateMapViewModel) {
        viewModel.creativeObjectListSubject
            .sink { [weak self] creativeObjectList in
                // creativeObjectList를 처리하는 로직을 작성합니다
                self?.objectList = creativeObjectList
                self?.appendMap(with: self?.objectList ?? [])
            }.store(in: &subscriptions)
        
    }
    
    private func appendMap(with object: [CreativeObject]) {
        mapList.append(CreativeMapModel(titleLabel: "Slot", objectList: object))
        // MARK: 추가한 Object들 출력예시
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
