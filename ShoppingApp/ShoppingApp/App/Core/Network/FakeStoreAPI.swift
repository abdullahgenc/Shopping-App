//
//  FakeStoreAPI.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 28.10.2022.
//

import Foundation
import Moya

let provider = MoyaProvider<FakeStoreAPI>()

enum FakeStoreAPI {
    case getProducts
    case getSingle(id: String)
    case search(type: String)
}

extension FakeStoreAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://fakestoreapi.com") else {
            fatalError("Base url not found.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "/products"
        case .getSingle(let id):
            return "/products/\(id)"
        case .search(let type):
            return "/products/category/\(type)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getProducts, .getSingle, .search:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
