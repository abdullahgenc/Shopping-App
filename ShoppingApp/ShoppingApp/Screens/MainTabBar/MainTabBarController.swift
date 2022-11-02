//
//  MainTabBarController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 29.10.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Shopping App"
        let images = ["product", "search", "person"]
        let titles = ["Products", "Search", "Profile"]
        
        let productsViewController = ProductsViewController(viewModel: ProductsViewModel())
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        
        let searchViewController = UIViewController()
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        
        let profileViewController = UIViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        viewControllers = [productsNavigationController,
                           searchNavigationController,
                           profileNavigationController]
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openBasket))
        
        guard let items = self.tabBar.items else {
            return
        }
        for x in 0..<items.count {
            items[x].image = UIImage(named: images[x])
            items[x].title = titles[x]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openBasket() {
        let basketViewController = UIViewController()
        present(basketViewController, animated: true)
    }
    
}
