//
//  OTPViewModel.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 17/01/2025.
//

import Foundation

class OTPViewModel {
    
    let email: String?
    let phone: String?
    
    var emailOtpCode: Bindable<String> = Bindable<String>()
    var mobileOtpCode: Bindable<String> = Bindable<String>()
    
    var showEmailOtpUIs: Bool
    var showMobileOtpUIs: Bool
    
    init(email: String? = nil, phone: String? = nil, showEmailOtpUIs: Bool = true, showMobileOtpUIs: Bool = true) {
        self.email = email
        self.phone = phone
//        if let emailOtpCode {
//            self.emailOtpCode.value = emailOtpCode
//        }
//        if let mobileOtpCode {
//            self.mobileOtpCode.value = mobileOtpCode
//        }
        self.showEmailOtpUIs = showEmailOtpUIs
        self.showMobileOtpUIs = showMobileOtpUIs
    }
    
}
