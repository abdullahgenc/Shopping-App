//
//  FireBaseFireStoreAccesible.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 28.10.2022.
//

import Foundation
import FirebaseFirestore

protocol FireBaseFireStoreAccessible {}

extension FireBaseFireStoreAccessible {
    var db: Firestore {
        Firestore.firestore()
    }
}
