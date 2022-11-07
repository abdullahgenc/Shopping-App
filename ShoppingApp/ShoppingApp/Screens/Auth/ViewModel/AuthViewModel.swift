//
//  AuthViewModel.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 28.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthViewModelChange {
    case didErrorOccurred(_ error: Error)
    case didSignUpSuccessful
}

final class AuthViewModel: SAViewModel {
    
    private let db = Firestore.firestore()
    private let defaults = UserDefaults.standard
    
    var changeHandler: ((AuthViewModelChange) -> Void)?
    
    func signUp(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }
            
            let user = User(username: username,
                            email: authResult?.user.email,
                            favorites: [])
            do {
                guard let data = try user.dictionary,
                      let id = authResult?.user.uid else {
                    return
                }
                
                self.defaults.set(id, forKey: "uid")
                
                self.db.collection("users").document(id).setData(data) { error in
                    
                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                    } else {
                        self.changeHandler?(.didSignUpSuccessful)
                    }
                }
            } catch {
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }

            guard let id = authResult?.user.uid else {
                return
            }
            
            self.defaults.set(id, forKey: "uid")
            completion()
        }
    }
    
    func saveUsername(username: String?) {
        guard let uid = uid,
              let username = username else {
            return
        }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error {
                self.changeHandler?(.didErrorOccurred(error))
            }
            self.db.collection("users").document(uid).updateData([
                "username": username
            ])
        }
    }
}

