//
//  AuthViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 27.10.2022.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private lazy var signInView: SignInView = {
        let view = SignInView()
        view.tag = 1
        return view
    }()
    
    private lazy var signUpView: SignUpView = {
        let view = SignUpView()
        view.tag = 2
        view.isHidden = true
        return view
    }()
    
    
    enum AuthType: String {
        case signIn = "Sign In"
        case signUp = "Sign Up"
        
        init(text: String) {
            switch text {
            case "Sign In":
                self = .signIn
            case "Sign Up":
                self = .signUp
            default:
                self = .signIn
            }
        }
    }
    
    var segmentedTitle: String = "Sign In"
    
    var authType: AuthType = .signIn {
        didSet {
            titleLabel.text = segmentedTitle
            confirmButton.setTitle(segmentedTitle, for: .normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var confirmButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSignInLayout()
        setupSignUpLayout()

        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 20.0


    }
    
    private func setupSignInLayout() {
        contentView.addSubview(signInView)
        signInView.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
            //            make.height.equalTo(300.0)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    private func setupSignUpLayout() {
        contentView.addSubview(signUpView)
        signUpView.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
            //            make.height.equalTo(300.0)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    
    @IBAction func didTapLoginButton(_ sender: UIButton) {

    }
    
    @IBAction func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        segmentedTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        var tag = (Int(), Int())
        if segmentedTitle == "Sign In" {
            tag = (1, 2)
        } else {
            tag = (2, 1)
        }
        UIView.animate(withDuration: 0.3) {
            self.contentView.viewWithTag(tag.1)?.alpha = .zero
        } completion: { _ in
            self.contentView.viewWithTag(tag.1)?.isHidden = true
            self.contentView.viewWithTag(tag.0)?.isHidden = false
            self.contentView.viewWithTag(tag.0)?.alpha = 1
        }
        
        authType = AuthType(text: segmentedTitle)
    }
}

