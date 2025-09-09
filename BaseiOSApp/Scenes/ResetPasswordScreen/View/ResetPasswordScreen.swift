//
//  ResetPasswordScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 08/09/2025.
//

import UIKit

class ResetPasswordScreen: UIViewController {
    
    static let identifier = "ResetPasswordScreen"
    
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var newPasswordIcon: UIImageView!
    @IBOutlet weak var confirmPasswordIcon: UIImageView!
    
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
        appNavigationCoordinator.popToSpecificVc(vc: SignInScreen.self)
    }
    
    //MARK: ButtonActions
    @IBAction func showNewPasswordBtn(_ sender: Any) {
        newPasswordField.isSecureTextEntry.toggle()
        newPasswordIcon.image = newPasswordField.isSecureTextEntry ? .showEyeIcon : .hideEyeIcon
    }
    
    @IBAction func showConfirmPasswordBtn(_ sender: Any) {
        confirmPasswordField.isSecureTextEntry.toggle()
        confirmPasswordIcon.image = confirmPasswordField.isSecureTextEntry ? .showEyeIcon : .hideEyeIcon
    }
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        let createAndValidatePayload = viewModel.createAndValidateResetPasswordPayload(newPassword: newPasswordField.text, confirmPassword: confirmPasswordField.text)
        if createAndValidatePayload.0 {
            print("Valid payload")
        }
        else {
            GenericToast.showToast(message: createAndValidatePayload.1 ?? "")
        }
    }
    
    
}

extension ResetPasswordScreen {
    
    private func bindViewModel() {
        
        
        
    }
    
}
