//
//  SignUpScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/08/2025.
//

import UIKit

class SignUpScreen: UIViewController {
    
    static let identifier = "SignUpScreen"
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    private var viewModel: SignUpViewModel
    
    init?(coder: NSCoder, viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUiElements()
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn])]))
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let createAndValidateSignUpPayload = viewModel.createSignInPayload(firstName: firstNameField.text, lastName: lastNameField.text, email: emailField.text, password: passwordField.text, confirmPassword: confirmPasswordField.text)
        if createAndValidateSignUpPayload.0 {
            print("Valid")
//            ActivityIndicator.shared.showActivityIndicator(view: view)
            viewModel.signUpApi(parameters: createAndValidateSignUpPayload.2)
        }
        else {
            GenericToast.showToast(message: createAndValidateSignUpPayload.1 ?? "")
        }
    }
    
}

extension SignUpScreen {
    private func bindViewModel() {
        
        viewModel.signUpResponse.bind { response in
            ActivityIndicator.shared.removeActivityIndicator()
        }
        
    }
}


