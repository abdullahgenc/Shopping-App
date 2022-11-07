//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import UIKit
import Kingfisher
import FirebaseFirestore

final class DetailViewController: SAViewController {
    
    var product: Product? {
        didSet {
            title = product?.title
            detailView.id = product?.id
            detailView.price = product?.price
            detailView.desc = product?.productDescription
            detailView.category = product?.category?.rawValue
            detailView.imageView.kf.setImage(with: URL(string: (product?.image)!))
            detailView.rate = product?.rating?.rate
            detailView.count = product?.rating?.count
        }
    }
    
    private let detailView = DetailView()
    
    private let defaults = UserDefaults.standard
    private let db = Firestore.firestore()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.delegate = self
        view = detailView
    }
}

extension DetailViewController: DetailViewDelegate {
    func addToFavorite(_ view: DetailView) {
        let id = "\(detailView.id!)"
        showAlert(title: "ITEM ADDED TO FAVORITE")
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        db.collection("users").document(uid).updateData([
            "favorites": FieldValue.arrayUnion([id])
        ])
    }
    
    func addToBasket(_ view: DetailView) {
        
        let id = "\(detailView.id!)"
        var productCount = detailView.stepperValue + 1
        showAlert(title: "\(productCount) ITEM(s) ADDED TO BASKET")
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else {
            return
        }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, error) in
            guard let data = querySnapshot?.data() else { return }
            if data[id] != nil {
                let dataCount = data[id] as! Int
                productCount += dataCount
            }
            var basketData = [String: Int]()
            basketData[id] = productCount

            self.db.collection("users").document(uid).setData(basketData, merge: true) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                }
            }
        }
    }
}
