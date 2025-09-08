//
//  OTPReusableScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 17/01/2025.
//

import UIKit

class OTPReusableScreen: UIView, NibInstantiatable {
    
    static let identifier = "OTPReusableScreen"
    
    @IBOutlet weak var navigationBar: UIStackView!
    @IBOutlet weak var emailOtpStackView: UIStackView!
    @IBOutlet weak var mobileOtpScreen: UIStackView!
    @IBOutlet weak var emailOtpLbl: UILabel!
    @IBOutlet weak var mobileOtpLbl: UILabel!
    @IBOutlet weak var emailOtpField: AEOTPTextField!
    @IBOutlet weak var mobileOtpField: AEOTPTextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    typealias buttonAction = ((Int, OTPViewModel?, OTPReusableScreen) -> Void)?
    var action: buttonAction = nil
    
    private var viewModel: OTPViewModel? = OTPViewModel()
    
    @discardableResult
    static func addOtpScreen(parentView: UIView, viewModel: OTPViewModel = OTPViewModel(), completion: buttonAction) -> OTPReusableScreen {
        let otpScreen: OTPReusableScreen = OTPReusableScreen.fromNib()
        otpScreen.action = completion
        otpScreen.setupOtpUI(viewModel: viewModel)
        DispatchQueue.main.async {
            otpScreen.frame = parentView.bounds
            if let parentStackView = parentView as? UIStackView{
                parentStackView.addArrangedSubview(otpScreen)
            }
            else{
                parentView.addSubview(otpScreen)
            }
        }
        return otpScreen
    }
    
    func setupOtpUI(viewModel: OTPViewModel? = nil) {
        self.viewModel = viewModel
        self.emailOtpStackView.isHidden = !(viewModel?.showEmailOtpUIs == true)
        
        var infoText = "A 6 digit code was sent to".localizeString(originalText: "A 6 digit code was sent to")
        emailOtpLbl.text = "\(infoText): \(viewModel?.email ?? "")"
        
//MARK: ForFuture - MobileOTP flow
        /*
         self.mobileOtpScreen.isHidden = !(viewModel?.showMobileOtpUIs == true)
         mobileOtpLbl.text = "A 6 digit code was sent to: \(viewModel?.phone ?? "")"
         */
        
//        CustomNavigationBar.addNavBar(parentView: navigationBar, title: "Verification".localizeString(originalText: "Verification")) { [weak self] btnIndex, _ in
//            if btnIndex == 0{
//                DispatchQueue.main.async {
//                    self?.removeFromSuperview()
//                }
//            }
//        }
        bindViewModel()
        setupOTPTextField()
        shouldEnableVerifyBtn(enable: false)
    }
    
    deinit {
        
        print("OTP deinit")
        
    }
    
    //MARK: ButtonActions
    @IBAction func resendEmailOtpBtn(_ sender: Any) {
        if let action {
            action(101, viewModel, self)
        }
    }
    
    @IBAction func resendMobileOtpBtn(_ sender: Any) {
        if let action {
            action(102, viewModel, self)
        }
    }
    
    @IBAction func verifyBtn(_ sender: Any) {
        if let action {
            action(0, viewModel, self)
        }
    }
    
}

extension OTPReusableScreen: AEOTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String, field: AEOTPTextField) {
        if field.tag == 101 {
            //Email otp
            print("Email otp: \(code)")
            viewModel?.emailOtpCode.value = code
        }
        else {
            //Mobile otp
            print("Mobile otp: \(code)")
            viewModel?.mobileOtpCode.value = code
        }
    }
    
    private func setupOTPTextField() {
        
        emailOtpField.tag = 101
        emailOtpField.otpDelegate = self
        emailOtpField.otpFontSize = 30
        emailOtpField.otpTextColor = .clr_black
        emailOtpField.configure()
        
//MARK: ForFuture - MobileOTP flow
        /*
         mobileOtpField.tag = 102
         mobileOtpField.otpDelegate = self
         mobileOtpField.otpFontSize = 30
         mobileOtpField.otpTextColor = .clr_black
         mobileOtpField.configure()
         */
        
    }
    
    private func shouldEnableVerifyBtn(enable: Bool) {
        verifyBtn.backgroundColor = enable ? .clr_primary : .clr_whitish_gray_two
        verifyBtn.isEnabled = enable
    }
    
    private func shouldEnableOtpBtn() {
        
        let showEmailOtpUIs = viewModel?.showEmailOtpUIs == true
        let showPhoneOtpUIs = viewModel?.showMobileOtpUIs == true
        
        let isEmailOtpValid = (viewModel?.emailOtpCode.value?.count ?? 0) == 6
        let isPhoneOtpValid = (viewModel?.mobileOtpCode.value?.count ?? 0) == 6
        
//MARK: ForFuture - MobileOTP flow
        /*
         if showEmailOtpUIs && showPhoneOtpUIs {
             shouldEnableVerifyBtn(enable: (isEmailOtpValid && isPhoneOtpValid))
         }
         else if showEmailOtpUIs {
             shouldEnableVerifyBtn(enable: isEmailOtpValid)
         }
         else if showPhoneOtpUIs {
             shouldEnableVerifyBtn(enable: isPhoneOtpValid)
         }
         else {
             shouldEnableVerifyBtn(enable: false)
         }
         */
        
        
        //Current implementation
        if showEmailOtpUIs {
            shouldEnableVerifyBtn(enable: isEmailOtpValid)
        }
        else {
            shouldEnableVerifyBtn(enable: false)
        }
        
        
    }
    
}

extension OTPReusableScreen {
    
    private func bindViewModel() {
        
        viewModel?.emailOtpCode.bind { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.shouldEnableOtpBtn()
            }
            
        }
        
        viewModel?.mobileOtpCode.bind { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.shouldEnableOtpBtn()
            }
            
        }
        
    }
    
}
