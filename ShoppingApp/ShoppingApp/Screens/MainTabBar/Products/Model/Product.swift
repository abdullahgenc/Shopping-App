//
//  Product.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 31.10.2022.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let productDescription: String?
    let category: Category?
    let image: String?
    let rating: Rating?

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case productDescription = "description"
        case category, image, rating
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double?
    let count: Int?
}

typealias Products = [Product]

extension Product {
    init(from dict: [String : Any]) {
        id = dict["id"] as? Int
        title = dict["title"] as? String
        price = dict["price"] as? Double
        productDescription = dict["description"] as? String
        category = dict["category"] as? Category
        image = dict["image"] as? String
        rating = dict["rating"] as? Rating
    }
}
