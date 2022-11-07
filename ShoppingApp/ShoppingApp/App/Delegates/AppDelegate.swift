//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 26.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import SnapKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 32.0
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        setupFirebase()
        
        return true
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        
        _ = Firestore.firestore()
    }


}

