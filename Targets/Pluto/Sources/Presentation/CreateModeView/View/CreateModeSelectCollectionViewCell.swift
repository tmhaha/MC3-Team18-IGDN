//
//  CreateModeSelectCollectionViewCell.swift
//  Pluto
//
//  Created by 홍승완 on 2023/07/12.
//  Copyright © 2023 tuist.io. All rights reserved.
//

import UIKit

class CreateModeSelectCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: CreateModeSelectCollectionViewCell.self)
    
    lazy var imageView = UIImageView()
    lazy var descriptions = UILabel()
    
    // MARK: - Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.removeFromSuperview()
        descriptions.removeFromSuperview()
    }
    
    // cell 재사용 문제 해결
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.isHidden = false
        descriptions.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    private func addSubviews() {
        
        [imageView, descriptions]
            .forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 21),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            descriptions.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 11),
            descriptions.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpViews() {
        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = .white
        
        imageView.image = UIImage(named: "creative_plus")
        
        descriptions.font = UIFont(name: "TASAExplorer-Bold", size: 20)
        descriptions.textColor = UIColor(hex: 0xB4C1FF)
        descriptions.text = "create your own journey!"

    }
    
    func configure(item: [CreativeMapModel]) {
        imageView.isHidden = true
        descriptions.isHidden = true
    }

}
