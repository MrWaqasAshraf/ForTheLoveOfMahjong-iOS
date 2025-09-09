//
//  ForgotPasswordScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 08/09/2025.
//

import UIKit

class ForgotPasswordScreen: UIViewController {
    
    static let identifier = "ForgotPasswordScreen"
    
    @IBOutlet weak var emailField: UITextField!
    
    private var otpUi: OTPReusableScreen?
    
    private var viewModel: ForgotPasswordViewModel
    
    init?(coder: NSCoder, viewModel: ForgotPasswordViewModel) {
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
    
    private func showOtpUI(inputViewModel: OTPViewModel = OTPViewModel()) {
        title = "Verification"
        otpUi = OTPReusableScreen.addOtpScreen(parentView: view, viewModel: inputViewModel) { [weak self] btnIndex, otpViewModel, otpScreen in
            //Verify otp screen
            if let otpViewModel {
                
                if btnIndex == 0 {
                    DispatchQueue.main.async {
//                        ActivityIndicator.shared.showActivityIndicator(view: otpScreen)
                    }
                    self?.viewModel.verifyOtpApi(emailOtp: otpViewModel.emailOtpCode.value, phoneOtp: otpViewModel.mobileOtpCode.value)
                    
                }
                else if btnIndex == 101 {
                    //Resend email otp
                    DispatchQueue.main.async {
//                        ActivityIndicator.shared.showActivityIndicator(view: otpScreen)
                    }
                    self?.viewModel.resendOtpApi(email: otpViewModel.email)
                }
                
//MARK: ForFuture - MobileOTP flow
                /*
                 else if btnIndex == 102 {
                     //Resend mobile otp
                     DispatchQueue.main.async {
                         ActivityIndicator.shared.showActivityIndicator(view: otpScreen)
                     }
                     self?.viewModel.resendOtpApi(phone: otpViewModel.phone)
                 }
                 */
                
                
            }
            
        }
    }
    
    //MARK: ButtonActions
    @IBAction func sendBtn(_ sender: Any) {
        
        //Temp disabled
//        showOtpUI(inputViewModel: OTPViewModel(email: emailField.text, showEmailOtpUIs: true, showMobileOtpUIs: false))
        
        let vc = AppUIViewControllers.resetPasswordScreen()
        appNavigationCoordinator.pushUIKit(vc)
        
    }
    
    
}

extension ForgotPasswordScreen {
    
    private func bindViewModel() {
        
    }
    
}
