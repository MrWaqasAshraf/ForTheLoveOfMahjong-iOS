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
    @IBOutlet weak var passwordEyeIcon: UIImageView!
    @IBOutlet weak var confirmPasswordEyeIcon: UIImageView!
    @IBOutlet weak var acceptanceTextView: UITextView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var termsSelectedImage: UIImageView!
    
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
    
    private func setupAgreementText(){
        let textFieldText = NSMutableAttributedString(string: "I agree to For The Love of Mahjong's Terms of Use and Privacy Policy")
        let attributeLinks = [("Privacy Policy", AppLink.privacyPolicy), ("Terms of Use", AppLink.termsOfService)]
        var attributes: [AttributeModel] = []
        for link in attributeLinks {
            attributes.append(.init(name: .link, value: link.1, range: (textFieldText.string as NSString).range(of: link.0)))
            attributes.append(.init(name: NSAttributedString.Key.foregroundColor, value: UIColor.clr_primary, range: (textFieldText.string as NSString).range(of: link.0)))
        }
        textFieldText.setupAttributes(attributes: attributes)
        let linkAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clr_primary, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        acceptanceTextView.attributedText = textFieldText
        acceptanceTextView.linkTextAttributes = linkAttributes
        DispatchQueue.main.async {
            self.acceptanceTextView.sizeToFit()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        let img2 = UIImage.info_icon_system.withRenderingMode(.alwaysTemplate)
        let barBtn2 = UIBarButtonItem(image: img2, style: .plain, target: self, action: #selector(showDialogForAutoApprovedEvents))
        barBtn2.tintColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .right, barButtons: [barBtn2])]))
        
        setupAgreementText()
        
    }
    
    @objc
    private func showDialogForAutoApprovedEvents() {
        let autoApprovedEvents: String = """
• You can post up to \(allowedEventsNumber) events without approval.
• Additional events will be approved within 24 hours by the admin.
• Events take 10–15 minutes to appear on the app after posting.
"""
        GenericAlert.showAlert(title: "Mahjong Events", message: autoApprovedEvents, actions: [.init(title: "Close", style: .default)], controller: self) { _, _, _ in }
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    private func goBackToMap() {
        appNavigationCoordinator.popToSpecificVc(vc: MainMapScreen.self)
    }
    
    private func shouldTermAccepted(accepted: Bool){
        signUpBtn.isEnabled = accepted
        signUpBtn.backgroundColor = accepted ? .clr_primary : .clr_gray_1
        termsSelectedImage.image = accepted ? .checkmarkSquareIconSystem : .unmarkSquareIconSystem
//        termsSelectedImage.tintColor = accepted ? .clr_primary : .clr_gray_1
    }
    
    //MARK: ButtonActions
    
    @IBAction func acceptTermBtn(_ sender: Any) {
        viewModel.termsSelected.value?.toggle()
    }
    
    
    @IBAction func signInBtn(_ sender: Any) {
        appNavigationCoordinator.pop()
    }
    
    @IBAction func showPasswordBtn(_ sender: Any) {
        passwordField.isSecureTextEntry.toggle()
        passwordEyeIcon.image = passwordField.isSecureTextEntry ? .showEyeIcon : .hideEyeIcon
    }
    
    @IBAction func showConfirmPasswordBtn(_ sender: Any) {
        confirmPasswordField.isSecureTextEntry.toggle()
        confirmPasswordEyeIcon.image = confirmPasswordField.isSecureTextEntry ? .showEyeIcon : .hideEyeIcon
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
        let createAndValidateSignUpPayload = viewModel.createSignInPayload(firstName: firstNameField.text, lastName: lastNameField.text, email: emailField.text, password: passwordField.text, confirmPassword: confirmPasswordField.text)
        if createAndValidateSignUpPayload.0 {
            print("Valid")
            ActivityIndicator.shared.showActivityIndicator(view: view)
            viewModel.signUpApi(parameters: createAndValidateSignUpPayload.2)
        }
        else {
            GenericToast.showToast(message: createAndValidateSignUpPayload.1 ?? "")
        }
    }
    
}

extension SignUpScreen {
    
    private func bindViewModel() {
        
        viewModel.signUpResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            GenericToast.showToast(message: response?.message ?? "")
            if response?.isSuccessful == true {
                
                profileFetched.value = true
                
                DispatchQueue.main.async {
                    self?.goBackToMap()
                }
            }
        }
        
        viewModel.termsSelected.bind { [weak self] termSelected in
            
            guard let termSelected else { return }
            
            DispatchQueue.main.async {
                self?.shouldTermAccepted(accepted: termSelected)
            }
        }
        
    }
}


