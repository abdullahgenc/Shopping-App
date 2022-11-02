//
//  ProductsView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import UIKit

final class ProductsView: UIView {
    // MARK: - Properties
    private let cellInset: CGFloat = 8.0
    private let cellMultiplier: CGFloat = 0.5
    private var cellDimension: CGFloat {
        UIScreen.main.bounds.width * cellMultiplier - cellInset
    }
    
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
        collectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        setupCollectionViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupCollectionViewLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
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
