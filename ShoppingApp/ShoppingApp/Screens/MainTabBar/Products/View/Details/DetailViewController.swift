//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
}
