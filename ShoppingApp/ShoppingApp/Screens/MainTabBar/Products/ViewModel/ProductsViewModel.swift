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

final class ProductsViewModel {
    
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
                    self.products = products
                } catch {
                    self.changeHandler?(.didErrorOccurred(error))
                }
            }
        }
    }

    func productForIndexPath(_ indexPath: IndexPath) -> Product? {
        products?[indexPath.row]
    }
}
