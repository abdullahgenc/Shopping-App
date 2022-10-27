//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 26.10.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.pushViewController(OnboardingViewController(), animated: true)
    }


}

