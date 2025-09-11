//
//  ReAuthModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 11/09/2025.
//

import Foundation

// MARK: - VerifyOtpResponse
struct VerifyOtpResponse: Codable {
    
    let success: Int?
    let message: String?
    let data: VerifyOtpData?
    
    var isSuccessful: Bool {
        var isSuccess: Bool = false
        if let success, success >= 200 && success < 300 {
            isSuccess = true
        }
        return isSuccess
    }
    
}

// MARK: - VerifyOtpData
struct VerifyOtpData: Codable {
    let resetToken, expiresIn: String?
}
