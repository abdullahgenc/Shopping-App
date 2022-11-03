//
//  SearchViewModel.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 2.11.2022.
//

import Foundation

enum SearchChanges {
    case didErrorOccurred(_ error: Error)
    case didFetchList
}

final class SearchViewModel {
    
    private var products: Products? {
        didSet {
            self.changeHandler?(.didFetchList)
        }
    }
    
    var changeHandler: ((SearchChanges) -> Void)?
    
    var numberOfItems: Int {
        products?.count ?? .zero
    }
    
    func fetchCategory(category: String) {
        provider.request(.search(type: category)) { result in
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
