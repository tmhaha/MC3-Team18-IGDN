//
//  CreativeMapCollectionViewCell.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class CreativeMapCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CreativeMapCollectionViewCell.self)

    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // cell 재사용 문제 해결
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    private func addSubviews() {
        
//        []
//            .forEach {
//                contentView.addSubview($0)
//                $0.translatesAutoresizingMaskIntoConstraints = false
//            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func setUpViews() {
        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = .white

    }
    
//    func configure(item: [CreativeMapModel]) {
//        imageView.isHidden = true
//        descriptions.isHidden = true
//    }
}
