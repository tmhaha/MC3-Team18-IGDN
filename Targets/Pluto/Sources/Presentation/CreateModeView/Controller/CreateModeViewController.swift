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
    
    override func loadView() {
        view = contentView
    }
    
    init(with viewModel: CreateModeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        setKeyboardObserverRemove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SettingData().selectedTheme.creative.uiColor
        
        setUpCollectionView()
        setUpTargets()
        setKeyboardObserver()
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
                case .reload:
                    self?.contentView.collectionView.reloadData()
                    print("RELOAD: \(self?.viewModel.mapList.count ?? 0) ") // MARK: DEBUG
                case .editButtonDidTapOutput(let indexPath):
                    let mapViewModel = CreateMapViewModel(map: self?.viewModel.mapList[indexPath.row], isEditing: true, indexPath: indexPath)
                    let vc = CreateMapViewController(self!.viewModel, mapViewModel)
                    self?.viewModel.bind(with: mapViewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                // TODO: objects를 안 받을 수도 있음. 이때 게임뷰로 화면전환 해야함
                case .playButtonDidTapOutput(let objects):

                     self?.navigationController?.pushViewController(
                       GameViewController(gameConstants: GameConstants(),
                                           map: objects),
                       animated: false)
                case .deleteButtonDidTapOutput(indexPath: _):
                    self?.contentView.collectionView.reloadData()
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
    
    private func setUpTargets() {
        contentView.backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
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
        let CELL_MAX_COUNT: Int = Constants.CELL_MAX_COUNT
        
        if indexPath.section == 0,
           collectionView.numberOfItems(inSection: 1) <  CELL_MAX_COUNT {
            input.send(.createMapButtonDidTap)
        } else {
            input.send(.cellDidTap)
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
        UserDefaultsManager.saveCreativeMapsToUserDefaults(viewModel.mapList)
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // 키보드의 높이 가져오기
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // 텍스트 필드가 가려지지 않도록 컬렉션 뷰의 컨텐츠 인셋 조정
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
            contentView.collectionView.contentInset = insets
            contentView.collectionView.scrollIndicatorInsets = insets
            
            // 텍스트 필드가 위치한 위치로 스크롤
            if let activeTextField = findActiveTextField() {
                let rect = contentView.collectionView.convert(activeTextField.frame, from: activeTextField.superview)
                contentView.collectionView.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    
    // 키보드가 사라질 때 호출되는 메서드
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentView.collectionView.contentInset = .zero
            self?.contentView.collectionView.scrollIndicatorInsets = .zero
        }
    }
    
    // 현재 활성화된 텍스트 필드를 찾는 메서드
    func findActiveTextField() -> UITextField? {
        for cell in contentView.collectionView.visibleCells {
            if let textField = cell.subviews.first(where: { $0 is UITextField }) as? UITextField, textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }
    
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setKeyboardObserverRemove() {
        NotificationCenter.default.removeObserver(self)
    }
    
}

