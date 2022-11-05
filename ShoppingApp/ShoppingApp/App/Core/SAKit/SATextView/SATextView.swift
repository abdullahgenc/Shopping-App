//
//  SATextView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 27.10.2022.
//

import UIKit

@IBDesignable
class SATextView: SAView {
    
    @IBInspectable
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var text: String? {
        textField.text
    }
    
    @IBInspectable
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    @IBInspectable
    var error: String? {
        didSet {
            if let error = error {
                errorLabel.text = error
                errorLabel.isHidden = false
            } else {
                errorLabel.isHidden = true
                errorLabel.text = nil
            }
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
}
