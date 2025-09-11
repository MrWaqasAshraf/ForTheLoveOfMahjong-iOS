//
//  ForgotPasswordViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 08/09/2025.
//

import Foundation

class ForgotPasswordViewModel {
    
    private(set) var forgotPasswordResponse: Bindable<GeneralResponse> = Bindable<GeneralResponse>()
    private(set) var resendOtpResponse: Bindable<GeneralResponse> = Bindable<GeneralResponse>()
    private(set) var verfiyOtpResponse: Bindable<VerifyOtpResponse> = Bindable<VerifyOtpResponse>()
    private var reAuthService: any ServicesDelegate
    private var verfiyReAuthService: any ServicesDelegate
    
    init(reAuthService: any ServicesDelegate = ReAuthService(), verfiyReAuthService: any ServicesDelegate = VerifyReAuthService()) {
        self.reAuthService = reAuthService
        self.verfiyReAuthService = verfiyReAuthService
    }
    
    func forgotPasswordApi(email: String? = nil) {
        reAuthService.forgotPasswordApi(email: email) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.forgotPasswordResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.forgotPasswordResponse.value = GeneralResponse(success: -1, message: error.localizedDescription)
            }
        }
    }
    
    func resendOtpApi(email: String? = nil) {
        
        reAuthService.resendOtpApi(email: email) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.resendOtpResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.resendOtpResponse.value = GeneralResponse(success: -1, message: error.localizedDescription)
            }
        }
        
    }
    
    func verifyOtpApi(email: String? = nil, emailOtp: String? = nil) {
        
        verfiyReAuthService.verifyOtpApi(email: email, otp: emailOtp) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.verfiyOtpResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.verfiyOtpResponse.value = VerifyOtpResponse(success: -1, message: error.localizedDescription, data: nil)
            }
        }
        
    }
    
}
