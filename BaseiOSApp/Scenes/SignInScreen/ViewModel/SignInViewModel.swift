//
//  SignInViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/08/2025.
//

import Foundation

class SignInViewModel {
    
    private(set) var loginResponse: Bindable<UserResponse> = Bindable<UserResponse>()
    
    private var userService: any ServicesDelegate
    
    init(userService: any ServicesDelegate = UserService()) {
        self.userService = userService
    }
    
    func loginApi(email: String?, password: String?) {
        userService.loginApi(email: email, password: password) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                if data?.isSuccessful == true, let userModel = data?.data {
                    appUserData = userModel
                }
                self?.loginResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.loginResponse.value = UserResponse(success: -1, message: error.localizedDescription)
            }
        }
    }
    
}
