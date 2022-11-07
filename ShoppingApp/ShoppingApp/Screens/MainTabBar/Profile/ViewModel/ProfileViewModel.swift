//
//  ProfileViewModel.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 4.11.2022.
//

import UIKit
import FirebaseFirestore

final class ProfileViewModel: SAViewModel {
    
    private var products = [Product]()
    
    var numberOfItems: Int {
        products.count
    }
    
    var username = String()
    var profileImage = UIImage()
    
    func productForIndexPath(_ indexPath: IndexPath) -> Product? {
        products[indexPath.row]
    }
    
    func fetchUser(_ completion: @escaping (Error?) -> Void) {
        
        guard let uid = uid else { return }
        
        db.collection("users").document(uid).getDocument() { (querySnapshot, err) in
            guard let data = querySnapshot?.data() else { return }
            let user = User(from: data)
            self.username = user.username!
            self.profileImage = UIImage(named: "person")!
            completion(nil)
        }
    }
    
    func fetchFavorites(_ completion: @escaping (Error?) -> Void) {

        products = []
        guard let uid = uid else { return }

        db.collection("users").document(uid).getDocument() { (querySnapshot, error) in
            guard let data = querySnapshot?.data() else { return }
            let user = User(from: data)
            self.username = user.username!
            self.profileImage = UIImage(named: "person")!

            user.favorites?.forEach({ productId in
                self.db.collection("products").document(productId).getDocument { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(error)
                    } else {
                        guard let data = querySnapshot?.data() else { return }
                        let product = Product(from: data)
                        self.products.append(product)
                        completion(nil)
                    }
                }
            })
        }
    }
}
