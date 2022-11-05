//
//  ProductsViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 29.10.2022.
//

import UIKit
import Kingfisher

final class ProductsViewController: SAViewController {
    
    // MARK: - Properties
    private let mainView = ProductsView()
    private var viewModel: ProductsViewModel

    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        mainView.setCollectionViewDelegate(self, andDataSource: self)
        title = "Products"
        
        viewModel.changeHandler = {change in
            switch change {
            case .didFetchList:
                self.mainView.refresh()
            case .didErrorOccurred(let error):
                self.showError(error)
            }
        }
        viewModel.fetchProducts()
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.product = viewModel.productForIndexPath(indexPath)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductsCollectionViewCell
        
        guard let product = viewModel.productForIndexPath(indexPath),
              let image = product.image
        else {
            fatalError("product not found")
        }
        cell.imageView.kf.setImage(with: URL(string: image))
        cell.title = product.title
        
        return cell
    }
}
