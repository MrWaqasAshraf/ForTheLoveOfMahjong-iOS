//
//  ProfileScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 08/09/2025.
//

import Foundation

class ProfileScreenViewModel {
    
    private(set) var deleteUserResponse: Bindable<GeneralResponseTwo> = Bindable<GeneralResponseTwo>()
    private var deleteUserService: any ServicesDelegate
    
    init(deleteUserService: any ServicesDelegate = DeleteUserService()) {
        self.deleteUserService = deleteUserService
    }
    
    func deleteUserApi() {
        deleteUserService.deleteUserApi { [weak self] result in
            switch result{
            case .success((let data, let json, _)):
                if data?.success == true {
                    UserDefaultsHelper.removeUserAndToken()
                }
                self?.deleteUserResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.deleteUserResponse.value = GeneralResponseTwo(success: false, message: error.localizedDescription)
            }
        }
    }
    
}
