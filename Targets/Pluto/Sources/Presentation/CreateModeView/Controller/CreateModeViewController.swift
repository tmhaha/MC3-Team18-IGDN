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
    private var cellSubscriptions: [IndexPath: Set<AnyCancellable>] = [:]
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
        setUpCollectionView();
        bind()
        
    }
    
    //TODO: 추후 삭제
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
                    self?.contentView.collectionView.reloadData()
                case .presentSelectMapView:
                    // TODO: 화면 전환
                    self?.contentView.collectionView.reloadData()
                case .reload:
                    self?.contentView.collectionView.reloadData()
                    print("RELOAD: \(self?.viewModel.mapList.count ?? 0) ") // MARK: DEBUG
                case .editButtonDidTapOutput(let indexPath):
                    print("'''VC에서의 editButton으로 인한 화면전환'''")// MARK: DEBUG
                    // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 뷰로 연결 -> 뷰 전환

                    let mapViewModel = CreateMapViewModel(creativeObjectList: self?.viewModel.mapList[indexPath.row].objectList, isEditing: true, indexPath: indexPath)
                    let vc = CreateMapViewController(self!.viewModel, mapViewModel)
                    self?.viewModel.bind(with: mapViewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                    // TODO: edit 버튼 눌러서 해당 VC에 objectList를 화면에 띄우기 -> OK
                    // TODO: 뒤로가기 버튼하면 원래 CreateModeViewController로 돌아오기
                    // TODO: 뒤로가기 버튼 삭제시 삭제하고 VM 리스트에서 해당 데이터 지우기
                    // TODO: 저장버튼 클릭 시 해당하는 mapList[indexPath.row].objectList를 update하기 -> OK

                case .playButtonDidTapOutput:
                    print("'''VC에서의 playButton으로 인한 화면전환'''")// MARK: DEBUG
                    // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 게임화면으로 연결 -> 뷰 전환
                case .editTitleButtonDidTapOutput:
                    print("'''VC에서의 editTitleButton으로 인한 화면전환'''")// MARK: DEBUG
                    // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> title 변경하여 화면을 변경
                }
            }
            .store(in: &subscriptions)
        
        
    }
    
    private func bindInCell(with cellInput: PassthroughSubject<CreateModeViewModel.Input, Never>, cell: CreateModeSelectCollectionViewCell, indexPath: IndexPath) {
        let output = viewModel.transform(input: cellInput.eraseToAnyPublisher())
        output.receive(on: RunLoop.main)
            .sink { [weak self] event in
                print("event: \(event)")
            }
            .store(in: &cellSubscriptions[indexPath, default: Set<AnyCancellable>()]) // 해당 indexPath에 대한 구독 저장
    }
    
    private func setUpCollectionView() {
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
            print(">> viewModel.mapList.count: \(viewModel.mapList.count)")// MARK: DEBUG
            return viewModel.mapList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateModeSelectCollectionViewCell.identifier, for: indexPath) as? CreateModeSelectCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(item: [], section: indexPath.section, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CreateModeSelectCollectionViewCell else {
            return
        }
        self.configureCell(cell, at: indexPath)
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
            print(">>> 선택한 게임뷰로 넘어갑니다.")// MARK: DEBUG
            input.send(.selectButtonDidTap(indexPath: indexPath))
        }
    }
    
    private func configureCell(_ cell: CreateModeSelectCollectionViewCell, at indexPath: IndexPath) {
        // 이전에 구독한 sink 클로저를 취소
        cellSubscriptions[indexPath]?.forEach { $0.cancel() }
        cellSubscriptions[indexPath]?.removeAll()
        
        // 해당 indexPath에 대한 구독이 없을 경우에만 bindInCell 호출
        if cellSubscriptions[indexPath] == nil {
            bindInCell(with: cell.input, cell: cell, indexPath: indexPath)
        }
    }
    
}
