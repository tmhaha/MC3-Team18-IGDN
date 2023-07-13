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
    var viewModel: CreateModeViewModel!
    private let input = PassthroughSubject<CreateModeViewModel.Input, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x002EFE)
        
        viewModel = CreateModeViewModel()
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
                    let vc = CreateMapViewController()
                    vc.configure(with: self!.viewModel)
                    //vc.modalPresentationStyle = .fullScreen
                    //self?.present(vc, animated: false)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    print(">>> receive: presentCreateMapView")
                    self?.contentView.collectionView.reloadData()
                case .presentSelectMapView:
                    // TODO: 화면 전환
                    print(">>> receive: presentSelectMapView")
                    self?.contentView.collectionView.reloadData()
                case .saveMap:
                    // TODO: collectionView Reload
                    print(">>> receive: saveMap")
                    self?.contentView.collectionView.reloadData()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
    
//    @objc private func buttonDidTap(_ sender: UIButton) {
//        switch sender {
//        case self.contentView.createMapButton:
//            input.send(.createMapButtonDidTap)
//        case self.contentView.selectMapButton:
//            input.send(.selectButtonDidTap)
//        default:
//            fatalError()
//        }
//    }
    
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
            print(">> viewModel.mapList.count: \(viewModel.mapList.count)")
            return viewModel.mapList.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateModeSelectCollectionViewCell.identifier, for: indexPath) as? CreateModeSelectCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.configure(item: [])
        } else {
            // TODO: '+' 버튼이 있는 두 번째 섹션에서 event 처리
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width - 70, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            input.send(.createMapButtonDidTap)
        } else {
            print(">>> 선택한 게임뷰로 넘어갑니다.")
            input.send(.selectButtonDidTap)
        }
    }
}
