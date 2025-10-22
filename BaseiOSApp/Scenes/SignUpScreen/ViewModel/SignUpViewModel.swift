//
//  SignUpViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/08/2025.
//

import Foundation

class PasswordAuthenticationService {
    
    static let shared: PasswordAuthenticationService = PasswordAuthenticationService()
    
    private init(){}
    
    func authenticatedPasswordWithConfirmation(passwordParamKey: String, newPassword: String?, confirmPassword: String?) -> (Bool, String, [String: Any]) {
        var isValid: Bool = true
        var parameters: [String: Any] = [:]
        var validationMessage: String = ""
        if let newPassword, newPassword != "" {
            let isValidPassword = validatePassword(string: newPassword)
            let isValidConfirmPassword = confirmPasswordValidity(password: newPassword, confirmPassword: confirmPassword)
            
            if let confirmPassword, confirmPassword != "" {
                if isValidPassword && isValidConfirmPassword {
                    parameters.updateValue(newPassword, forKey: passwordParamKey)
                }
                else if !isValidPassword {
                    isValid = false
                    validationMessage += "Please enter a valid password"
                    return (isValid, validationMessage, [:])
                }
                else {
                    isValid = false
                    validationMessage += "Password mismatch"
                    return (isValid, validationMessage, [:])
                }
            }
            else {
                isValid = false
                validationMessage = "Password mismatch"
                return (isValid, validationMessage, [:])
            }
            
        }
        else {
            isValid = false
            validationMessage += "Valid Passwords, "
        }
        
        return (isValid, validationMessage, parameters)
    }
    
    func validatePassword(string: String?) -> Bool{
//        password = string
        var isValid: Bool = false
        if let string = string{
            var total = 0
            
            if string.count >= 8{
                
                var containsSpecialCharacter = false
                var containsUppercase = false
                var containsLowercase = false
                var containsNumber = false
                
                for character in string{
                    if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character) {
                        containsUppercase = true
                    }
                    
                    if "abcdefghijklmnopqrstuvwxyz".contains(character) {
                        containsLowercase = true
                    }
                    
                    if "0123456789".contains(character) {
                        containsNumber = true
                    }
                    
                    if "!£$%&/()[]{}<>~`@+'|=?^;:_ç°§*,.\"\\-_".contains(character) {
                        containsSpecialCharacter = true
                    }
                    
                }
                
                if containsUppercase{
                    AppLogger.info("Has upper case character")
                    total += 1
                }
                
                if containsLowercase{
                    AppLogger.info("Has lower case character")
                    total += 1
                }
                
                if containsNumber{
                    AppLogger.info("Has number character")
                    total += 1
                }
                
                if containsSpecialCharacter{
                    AppLogger.info("Has special character")
                    total += 1
                }
                
                if total < 4 && total > 2{
                    //Medium
                    AppLogger.info("Medium")
                    isValid = false
//                    return PasswordStrengthModel(strength: .medium, strenghtBarColor: .clr_orange, bars: 2)
                }
                else if total < 3{
                    //Weak
                    AppLogger.info("Weak")
                    isValid = false
//                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 1)
                }
                else{
                    //Strong
                    AppLogger.info("Strong")
                    isValid = true
//                    return PasswordStrengthModel(strength: .strong, strenghtBarColor: .clr_primary, bars: 3)
                }
                
            }
            else{
                if string.count != 0{
                    //Weak
                    AppLogger.info("Weak")
                    isValid = false
//                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 1)
                }
                else{
                    //Empty
                    AppLogger.info("Empty")
                    isValid = false
//                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 0)
                }
            }
        }
        else{
            //Empty
            AppLogger.info("Empty")
            isValid = false
//            return PasswordStrengthModel(strength: .weak, strenghtBarColor: "", bars: 0)
        }
        return isValid
    }
    
    func confirmPasswordValidity(password: String?, confirmPassword: String?) -> Bool{
        if let confirmPassword{
            if password == confirmPassword{
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
}

class SignUpViewModel {
    
    //For UI
    var termsSelected: Bindable<Bool> = Bindable(false)
    
    //For APIs
    private(set) var resetToken: String?
    private(set) var signUpResponse: Bindable<UserResponse> = Bindable<UserResponse>()
    private(set) var resetPasswordResponse: Bindable<GeneralResponse> = Bindable<GeneralResponse>()
    private var userService: any ServicesDelegate
    private var reAuthService: any ServicesDelegate
    
    init(resetToken: String? = nil, userService: any ServicesDelegate = UserService(), reAuthService: any ServicesDelegate = ReAuthService()) {
        self.resetToken = resetToken
        self.userService = userService
        self.reAuthService = reAuthService
    }
    
    func createAndValidateResetPasswordPayload(newPassword: String?, confirmPassword: String?) -> (Bool, String?, [String: Any]) {
        
        var validationWithPayload =  PasswordAuthenticationService.shared.authenticatedPasswordWithConfirmation(passwordParamKey: "newPassword", newPassword: newPassword, confirmPassword: confirmPassword)
        
        if let resetToken, resetToken != "" {
            validationWithPayload.2.updateValue(resetToken, forKey: "resetToken")
        }
        else {
            validationWithPayload.0 = false
            validationWithPayload.1 += "Valid Token, "
        }
        
        if !validationWithPayload.1.isEmpty, validationWithPayload.1.count > 2 {
            validationWithPayload.1 = String(validationWithPayload.1.dropLast(2))
            validationWithPayload.1 += " Required"
        }
        
        return validationWithPayload
        
//        var isValid: Bool = true
//        var parameters: [String: Any] = ["role":"user"]
//        var validationMessage: String = ""
//        if let newPassword, newPassword != "" {
//            let isValidPassword = validatePassword(string: newPassword)
//            let isValidConfirmPassword = confirmPasswordValidity(password: newPassword, confirmPassword: confirmPassword)
//            
//            if let confirmPassword, confirmPassword != "" {
//                if isValidPassword && isValidConfirmPassword {
//                    parameters.updateValue(newPassword, forKey: "newPassword")
//                }
//                else if !isValidPassword {
//                    isValid = false
//                    validationMessage += "Please enter a valid password"
//                    return (isValid, validationMessage, [:])
//                }
//                else {
//                    isValid = false
//                    validationMessage += "Password mismatch"
//                    return (isValid, validationMessage, [:])
//                }
//            }
//            else {
//                isValid = false
//                validationMessage = "Password mismatch"
//                return (isValid, validationMessage, [:])
//            }
//            
//        }
//        else {
//            isValid = false
//            validationMessage += "Valid Passwords, "
//        }
//        
//        if !validationMessage.isEmpty, validationMessage.count > 2 {
//            validationMessage = String(validationMessage.dropLast(2))
//            validationMessage += " Required"
//        }
//        
//        return (isValid, validationMessage, parameters)
        
    }
    
    func resetPasswordApi(payload: [String: Any]?) {
        reAuthService.resetPasswordApi(payload: payload) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.resetPasswordResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.resetPasswordResponse.value = GeneralResponse(success: -1, message: error.localizedDescription)
            }
        }
    }
    
    func createSignInPayload(
        firstName: String?,
        lastName: String?,
        email: String?,
        password: String?,
        confirmPassword: String?
    ) ->(Bool, String?, [String: Any]) {
        
        /*
         {
           "firstName": "Waqas",
           "lastName": "Test",
           "email": "waqas@example.com",
           "password": "Test@1234",
           "role": "user"
         }
         */
        
        var isValid: Bool = true
        var parameters: [String: Any] = ["role":"user"]
        var validationMessage: String = ""
        
        if let firstName, firstName != "" {
            parameters.updateValue(firstName, forKey: "firstName")
        }
        else {
            isValid = false
            validationMessage += "First Name, "
        }
        if let lastName, lastName != "" {
            parameters.updateValue(lastName, forKey: "lastName")
        }
        else {
            isValid = false
            validationMessage += "Last Name, "
        }
        if let email, email != "" && email.validateEmail() {
            parameters.updateValue(email, forKey: "email")
        }
        else {
            isValid = false
            validationMessage += "Valid Email, "
        }
        
//        if let password, password != "" {
//            let isValidPassword = validatePassword(string: password)
//            let isValidConfirmPassword = confirmPasswordValidity(password: password, confirmPassword: confirmPassword)
//            
//            if let confirmPassword, confirmPassword != "" {
//                if isValidPassword && isValidConfirmPassword {
//                    parameters.updateValue(password, forKey: "password")
//                }
//                else if !isValidPassword {
//                    isValid = false
//                    validationMessage += "Please enter a valid password"
//                    return (isValid, validationMessage, [:])
//                }
//                else {
//                    isValid = false
//                    validationMessage += "Password mismatch"
//                    return (isValid, validationMessage, [:])
//                }
//            }
//            else {
//                isValid = false
//                validationMessage = "Password mismatch"
//                return (isValid, validationMessage, [:])
//            }
//            
//        }
//        else {
//            isValid = false
//            validationMessage += "Valid Passwords, "
//        }
        
        var validationPasswordWithPayload =  PasswordAuthenticationService.shared.authenticatedPasswordWithConfirmation(passwordParamKey: "password", newPassword: password, confirmPassword: confirmPassword)
        isValid = validationPasswordWithPayload.0
        validationMessage = validationPasswordWithPayload.1
        for pair in validationPasswordWithPayload.2 {
            parameters.updateValue(pair.value, forKey: pair.key)
        }
        
        if !validationMessage.isEmpty, validationMessage.count > 2 {
            validationMessage = String(validationMessage.dropLast(2))
            validationMessage += " Required"
        }
        return (isValid, validationMessage, parameters)
    }
    
    func signUpApi(parameters: [String: Any]?) {
        userService.signUpApi(parameters: parameters) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                if data?.isSuccessful == true, let userModel = data?.data {
                    appUserData = userModel
                }
                self?.signUpResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.signUpResponse.value = UserResponse(success: -1, message: error.localizedDescription)
            }
        }
    }
    
//    func validatePassword(string: String?) -> Bool{
////        password = string
//        var isValid: Bool = false
//        if let string = string{
//            var total = 0
//            
//            if string.count >= 8{
//                
//                var containsSpecialCharacter = false
//                var containsUppercase = false
//                var containsLowercase = false
//                var containsNumber = false
//                
//                for character in string{
//                    if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character) {
//                        containsUppercase = true
//                    }
//                    
//                    if "abcdefghijklmnopqrstuvwxyz".contains(character) {
//                        containsLowercase = true
//                    }
//                    
//                    if "0123456789".contains(character) {
//                        containsNumber = true
//                    }
//                    
//                    if "!£$%&/()[]{}<>~`@+'|=?^;:_ç°§*,.\"\\-_".contains(character) {
//                        containsSpecialCharacter = true
//                    }
//                    
//                }
//                
//                if containsUppercase{
//                    AppLogger.info("Has upper case character")
//                    total += 1
//                }
//                
//                if containsLowercase{
//                    AppLogger.info("Has lower case character")
//                    total += 1
//                }
//                
//                if containsNumber{
//                    AppLogger.info("Has number character")
//                    total += 1
//                }
//                
//                if containsSpecialCharacter{
//                    AppLogger.info("Has special character")
//                    total += 1
//                }
//                
//                if total < 4 && total > 2{
//                    //Medium
//                    AppLogger.info("Medium")
//                    isValid = false
////                    return PasswordStrengthModel(strength: .medium, strenghtBarColor: .clr_orange, bars: 2)
//                }
//                else if total < 3{
//                    //Weak
//                    AppLogger.info("Weak")
//                    isValid = false
////                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 1)
//                }
//                else{
//                    //Strong
//                    AppLogger.info("Strong")
//                    isValid = true
////                    return PasswordStrengthModel(strength: .strong, strenghtBarColor: .clr_primary, bars: 3)
//                }
//                
//            }
//            else{
//                if string.count != 0{
//                    //Weak
//                    AppLogger.info("Weak")
//                    isValid = false
////                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 1)
//                }
//                else{
//                    //Empty
//                    AppLogger.info("Empty")
//                    isValid = false
////                    return PasswordStrengthModel(strength: .weak, strenghtBarColor: .clr_red, bars: 0)
//                }
//            }
//        }
//        else{
//            //Empty
//            AppLogger.info("Empty")
//            isValid = false
////            return PasswordStrengthModel(strength: .weak, strenghtBarColor: "", bars: 0)
//        }
//        return isValid
//    }
//    
//    func confirmPasswordValidity(password: String?, confirmPassword: String?) -> Bool{
//        if let confirmPassword{
//            if password == confirmPassword{
//                return true
//            }
//            else{
//                return false
//            }
//        }
//        else{
//            return false
//        }
//    }
    
}
