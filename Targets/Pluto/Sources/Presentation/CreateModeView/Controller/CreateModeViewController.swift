//
//  CreateModeViewController.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/10.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit
import Combine

class CreateModeViewController: UIViewController {

    private lazy var contentView = CreateModeView()
    private let input = PassthroughSubject<CreateModeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: CreateModeViewModel!
    var creativeMapViewModel: CreateMapViewModel!
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x2244FF)
        
        creativeMapViewModel = CreateMapViewModel()
        viewModel = CreateModeViewModel(creativeMapViewModel: creativeMapViewModel)
        setUpTargets()
        setUpSettings();
        bind()
    }
    
    private func setUpTargets() {
//        contentView.selectMapButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
//        contentView.createMapButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    private func bind(){
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .presentCreateMapView:
                    // TODO: 화면 전환
                    let mapViewModel = CreateMapViewModel()
                    let vc = CreateMapViewController(self!.viewModel, mapViewModel)
                    self?.viewModel.bind(with: mapViewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    print(">>> receive: presentCreateMapView")
                    self?.contentView.collectionView.reloadData()
                case .presentSelectMapView:
                    // TODO: 화면 전환
                    print(">>> receive: presentSelectMapView")
                    self?.contentView.collectionView.reloadData()
                case .reload:
                    self?.contentView.collectionView.reloadData()
                    print("RELOAD: \(self?.viewModel.mapList.count)")
                    
                }
            }
            .store(in: &subscriptions)
        
        
    }
    
    private func setUpSettings() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }

}

extension CreateModeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            print(">> viewModel.mapList.count: \(viewModel.mapList.count)")
            return viewModel.mapList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateModeSelectCollectionViewCell.identifier, for: indexPath) as? CreateModeSelectCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(item: [], section: indexPath.section)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.layer.frame.width - 80, height: 100)
        } else {
            return CGSize(width: collectionView.layer.frame.width - 80, height: 150)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            input.send(.createMapButtonDidTap)
        } else {
            print(">>> 선택한 게임뷰로 넘어갑니다.")
            input.send(.selectButtonDidTap)
        }
    }
}
