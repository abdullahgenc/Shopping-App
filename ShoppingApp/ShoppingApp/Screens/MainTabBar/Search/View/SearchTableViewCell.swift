//
//  SearchTableViewCell.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 3.11.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    var image: UIImage? {
        didSet {
            productImageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            productNameLabel.text = title
        }
    }
    
    private(set) lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(productImageView)
        addSubview(productNameLabel)
        
        productImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.leading.equalToSuperview().offset(16.0)
            make.width.equalTo(UIScreen.main.bounds.width * 0.3)
            make.height.equalTo(UIScreen.main.bounds.width * 0.3).priority(.high)
        }
        
        productNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(productImageView.snp.trailing).offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
