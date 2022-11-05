//
//  User.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 28.10.2022.
//

import Foundation

struct User: Encodable {
    let username: String?
    let email: String?
}

extension User {
    init(from dict: [String: Any]) {
        username = dict["username"] as? String
        email = dict["email"] as? String
    }
}
