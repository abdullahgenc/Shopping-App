//
//  ProfileViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 4.11.2022.
//

import UIKit
import Kingfisher
import FirebaseAuth

final class ProfileViewController: SAViewController {
    
    // MARK: - Properties
    private let mainView = ProfileView()
    private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
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
        title = "Profile"
        
        viewModel.fetchUser { error in
            if let error = error {
                self.showError(error)
            } else {
                self.mainView.title = self.viewModel.username
                self.mainView.image = self.viewModel.profileImage
            }
        }
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "exit"), for: .normal)
        button.addTarget(self, action: #selector(self.clickedSignOut), for: .touchUpInside)
        
        let rightButtonBar = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightButtonBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchFavorites() { error in
            if let error = error {
                self.showError(error)
            } else {
                self.mainView.refresh()
            }
        }
    }
    
    @objc
    private func clickedSignOut() {
        showAlert(title: "Warning", message: "Are you sure to sign out?", cancelButtonTitle: "Cancel") { _ in
            print("SIGNED OUT")
            do {
                try Auth.auth().signOut()
                self.tabBarController?.navigationController?.popViewController(animated: true)
            } catch {
                self.showError(error)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("CELL-\(indexPath.row) TAPPED")
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
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
