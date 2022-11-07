//
//  OnboardingView.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 26.10.2022.
//

import UIKit

final class OnboardingView: SAView {
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}
