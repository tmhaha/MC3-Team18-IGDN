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
        setUpCollectionView();
        bind()
        
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
                    let mapViewModel = CreateMapViewModel(map: self?.viewModel.mapList[indexPath.row], isEditing: true, indexPath: indexPath)
                    let vc = CreateMapViewController(self!.viewModel, mapViewModel)
                    self?.viewModel.bind(with: mapViewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                case .playButtonDidTapOutput:
                    print("'''VC에서의 playButton으로 인한 화면전환'''")// MARK: DEBUG
                    // TODO: 탭한 editButton의 cell이 몇 번째 indexPath.row인지 알아내서 해당하는 index의 mapList의 정보를 불러오기 -> objectList를 불러와서 해당 object들이 배치되어있는 게임화면으로 연결 -> 뷰 전환
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
        cell.configure(item: viewModel.mapList, section: indexPath.section, indexPath: indexPath)
        cell.title.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CreateModeSelectCollectionViewCell else {
            return
        }
        self.configureCell(cell, at: indexPath)
        self.configureCellName(cell: cell, indexPath: indexPath)
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
    
    
    private func configureCellName(cell: UICollectionViewCell, indexPath: IndexPath) {
        guard let cell = cell as? CreateModeSelectCollectionViewCell else {
            return
        }
        cell.title.autocapitalizationType = .none
        cell.title.spellCheckingType = .no
        cell.title.autocorrectionType = .no
        cell.title.returnKeyType = .done
        cell.title.keyboardType = UIKeyboardType.emailAddress
        cell.editTitleButton.tag = indexPath.row
        cell.title.tag = indexPath.row
        cell.editTitleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        // 선택한 editTitle버튼이 있는 cell의 title이라는 TextField를 활성화 시키고 싶음
        let indexPath = IndexPath(row: sender.tag, section: 1)
        if let cell = contentView.collectionView.cellForItem(at: indexPath) as? CreateModeSelectCollectionViewCell {
            cell.title.becomeFirstResponder()
        }
    }

}

extension CreateModeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            return false
        }
        viewModel.mapList[textField.tag].titleLabel = textField.text!

        textField.resignFirstResponder()
        return true
    }
}
