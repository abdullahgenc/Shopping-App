//
//  ProfileView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 4.11.2022.
//

import UIKit

final class ProfileView: UIView {

    // MARK: - Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private var profileImageDimension: CGFloat {
        UIScreen.main.bounds.width * 0.3
    }
    private var cellDimension: CGFloat {
        UIScreen.main.bounds.width * 0.8
    }
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
        imageView.layer.cornerRadius = profileImageDimension / 2.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textColor = .white
        label.text = "Favorite Products"
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8.0
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.systemGray2.cgColor
        label.backgroundColor = .orange
        return label
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellDimension,
                                     height: cellDimension)
        return flowLayout
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        collectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.leading.equalToSuperview().offset(16.0)
            make.width.equalTo(profileImageDimension)
            make.height.equalTo(profileImageDimension).priority(.high)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.centerY)
            make.leading.equalTo(imageView.snp.trailing).offset(24.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
        
        addSubview(favoriteLabel)
        favoriteLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(cellDimension * 1.25)
            make.height.equalTo(cellDimension * 0.1)
        }

        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
            make.top.equalTo(favoriteLabel.snp.bottom).offset(16.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegate,
                                   andDataSource dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
