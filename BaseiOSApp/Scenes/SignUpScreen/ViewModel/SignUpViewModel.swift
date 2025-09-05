//
//  SignUpViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/08/2025.
//

import Foundation

class SignUpViewModel {
    
    private(set) var signUpResponse: Bindable<UserResponse> = Bindable<UserResponse>()
    
    private var userService: any ServicesDelegate
    
    init(userService: any ServicesDelegate = UserService()) {
        self.userService = userService
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
        if let password, password != "" {
            let isValidPassword = validatePassword(string: password)
            let isValidConfirmPassword = confirmPasswordValidity(password: password, confirmPassword: confirmPassword)
            
            if let confirmPassword, confirmPassword != "" {
                if isValidPassword && isValidConfirmPassword {
                    parameters.updateValue(password, forKey: "password")
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
                self?.signUpResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.signUpResponse.value = UserResponse(status: -1, message: error.localizedDescription)
            }
        }
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
