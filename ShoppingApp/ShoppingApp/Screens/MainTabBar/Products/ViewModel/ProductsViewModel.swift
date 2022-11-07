//
//  ProductsViewModel.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import Foundation

enum ProductsChanges {
    case didErrorOccurred(_ error: Error)
    case didFetchList
}

final class ProductsViewModel: SAViewModel {
    
    private var products: Products? {
        didSet {
            self.changeHandler?(.didFetchList)
        }
    }
    
    var changeHandler: ((ProductsChanges) -> Void)?
    
    var numberOfItems: Int {
        products?.count ?? .zero
    }
    
    func fetchProducts() {
        provider.request(.getProducts) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.didErrorOccurred(error))
            case .success(let response):
                do {
                    let products = try JSONDecoder().decode(Products.self, from: response.data)
                    self.addProductsToFirebaseFirestore(products)
                    self.products = products
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }
    
    private func addProductsToFirebaseFirestore(_ products: [Product]?) {
        guard let products = products else {
            return
        }
        products.forEach { product in
            do {
                guard let data = try product.dictionary,
                      let id = product.id
                else {
                    return
                }
                
                db.collection("products").document(String(id)).setData(data) { error in
                    
                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                    }
                }
            } catch {
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }

    func productForIndexPath(_ indexPath: IndexPath) -> Product? {
        products?[indexPath.row]
    }
}
