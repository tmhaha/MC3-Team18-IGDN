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
        case reload
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
