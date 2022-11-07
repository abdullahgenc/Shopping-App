//
//  BasketViewModel.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 6.11.2022.
//

import Foundation
import FirebaseFirestore

enum BasketChanges {
    case didErrorOccurred(_ error: Error)
}

final class BasketViewModel: SAViewModel {
    
    private var products = [Product]()
    
    var changeHandler: ((BasketChanges) -> Void)?
    
    var numberOfItems: Int {
        products.count
    }
    
    var tupleArray: [(String, Int)] = []
    
    func fetchByIDs(idList: [String], completion: @escaping (Error?) -> Void) {
        for id in idList {
            provider.request(.getSingle(id: id)) { result in
                switch result {
                case .failure(let error):
                    self.changeHandler?(.didErrorOccurred(error))
                case .success(let response):
                    do {
                        let product = try JSONDecoder().decode(Product.self, from: response.data)
                        self.products.append(product)
                        completion(nil)
                    } catch {
                        self.changeHandler?(.didErrorOccurred(error))
                    }
                }
            }
        }
    }
    
    func productForIndexPath(_ indexPath: IndexPath) -> Product? {
        products[indexPath.row]
    }
    
    func totalPriceOfProducts(idAndCounts: [(String, Int)]) -> Double {
        var totalPrice = 0.0
        if products.count == idAndCounts.count && products.count > 0 {
            for index in 0...products.count - 1 {
                let countForID = idAndCounts.filter({ $0.0 == String(products[index].id!) })
                let count = countForID[.zero].1
                totalPrice += products[index].price! * Double(count)
            }
        }
        return round(totalPrice * 100)/100.0
    }
    
    func productIdAndCount(_ completion: @escaping (Error?) -> Void) {
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else { fatalError() }
        db.collection("users").document(uid).getDocument() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let data = querySnapshot?.data() else { return }
                let productDict = data.compactMapValues { $0 as? Int }
                self.tupleArray = productDict.map { ($0, $1) }
                completion(nil)
            }
        }
    }
    
    func updateBasket(_ basketData: [String: Int], _ completion: @escaping (Error?) -> Void) {
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else { return }
        db.collection("users").document(uid).setData(basketData, merge: true) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
                completion(nil)
            }
        }
    }
    
    func deleteItemFromBasket(_ productID: String, _ completion: @escaping (Error?) -> Void) {
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else { return }
        db.collection("users").document(uid).updateData([ productID: FieldValue.delete() ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("FieldValue successfully deleted")
                if let index = self.products.firstIndex(where: { $0.id == Int(productID) }) {
                    self.products.remove(at: index)
                }
                completion(nil)
            }
        }
    }
    
    func deleteAll(_ completion: @escaping (Error?) -> Void) {
        guard let uid = defaults.string(forKey: UserDefaultConstants.uid.rawValue) else { return }
        
        for product in products {
            db.collection("users").document(uid).updateData([ String(product.id!): FieldValue.delete() ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("FieldValue successfully deleted")
                }
            }
        }
        products = []
        completion(nil)
    }
}
