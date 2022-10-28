//
//  AuthViewController.swift
//  ShoppingApp
//
//  Created by Abdullah Genc on 27.10.2022.
//

import UIKit

final class AuthViewController: SAViewController {
    
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
    
    private let viewModel: AuthViewModel
    
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

    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Auth"
        
        setupSignInLayout()
        setupSignUpLayout()
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 20.0

        viewModel.changeHandler = { change in
            switch change {
            case .didErrorOccurred(let error):
                self.showError(error)
            case .didSignUpSuccessful:
                self.showAlert(title: "SIGN UP SUCCESSFUL!")
            }
        }
    }
    
    private func setupSignInLayout() {
        contentView.addSubview(signInView)
        signInView.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }

    private func setupSignUpLayout() {
        contentView.addSubview(signUpView)
        signUpView.snp.makeConstraints { make in
            make.center.equalTo(contentView.snp.center)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        switch authType {
        case .signIn:
            guard let email = signInView.emailTextView.text,
                  let password = signInView.passwordTextView.text else {
                return
            }

            viewModel.signIn(email: email, password: password) { [weak self] in
                guard let self = self else { return }

                self.navigationController?.pushViewController(UIViewController(), animated: true)
            }
        case .signUp:
            guard let email = signUpView.emailTextView.text,
                  let username = signUpView.usernameTextView.text,
                  let password = signUpView.passwordTextView.text,
                  let passwordAgain = signUpView.passwordAgainTextView.text else {
                return
            }
            
            if password == passwordAgain {
                viewModel.signUp(email: email, password: password, username: username)
                viewModel.saveUsername(username: username)
            } else {
                showAlert(title: "Error Occurred", message: "Passwords do not match!")
            }
        }
    }
    
    @IBAction func didValueChangedSegmentedControl(_ sender: UISegmentedControl) {
        segmentedTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        var tags = (Int(), Int())
        if segmentedTitle == "Sign In" {
            tags = (1, 2)
        } else {
            tags = (2, 1)
        }
        UIView.animate(withDuration: 0.3) {
            self.contentView.viewWithTag(tags.1)?.alpha = .zero
        } completion: { _ in
            self.contentView.viewWithTag(tags.1)?.isHidden = true
            self.contentView.viewWithTag(tags.0)?.isHidden = false
            self.contentView.viewWithTag(tags.0)?.alpha = 1
        }
        authType = AuthType(text: segmentedTitle)
    }
}

