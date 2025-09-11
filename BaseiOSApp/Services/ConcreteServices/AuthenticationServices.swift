//
//  AuthenticationServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/09/2025.
//

import Foundation

class UserService: ServicesDelegate {
    
    func loginApi(email: String?, password: String?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ()) {
        var parameters: [String: Any] = [:]
        if let email{
            parameters.updateValue(email, forKey: "email")
        }
        if let password{
            parameters.updateValue(password, forKey: "password")
        }
        if let fcm = appFcmToken {
            parameters.updateValue(fcm, forKey: "fcm")
        }
        getResponse(.post, endPoint: EndPoint.loginApi.rawValue, parameters: parameters, completion: completion)
    }
    
    func signUpApi(parameters: [String: Any]?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ()) {
        var mutableParameters = parameters
        if let fcm = appFcmToken {
            mutableParameters?.updateValue(fcm, forKey: "fcm")
        }
        getResponse(.post, endPoint: EndPoint.signUpApi.rawValue, parameters: mutableParameters, completion: completion)
    }
    
//    func updateUserProfileApi(name: String?, email: String?, image: URL?, phone: String?, mc: String?, dot: String?, completion: @escaping (Result<(UserResponse?, Int?), Error>) -> ()) {
//        var parameters: [String: Any] = [:]
//        var files: FileParameters?
//        if let email {
//            parameters.updateValue(email, forKey: "email")
//        }
//        if let userId = appUserData?.id{
//            parameters.updateValue(userId, forKey: "user_id")
//        }
//        if let name, !name.replacingOccurrences(of: " ", with: "").isEmpty {
//            parameters.updateValue(name, forKey: "name")
//        }
//        if let phone, !phone.replacingOccurrences(of: " ", with: "").isEmpty {
//            //MARK: For staging
//            parameters.updateValue(phone.replacingOccurrences(of: "+", with: ""), forKey: "phone")
//            
//            //MARK: For live
////            parameters.updateValue(phone, forKey: "phone")
//        }
//        if let mc {
//            parameters.updateValue(mc, forKey: "mc")
//        }
//        if let dot {
//            parameters.updateValue(dot, forKey: "dot")
//        }
//        if let image {
//            files = FileParameters(fileName: "image", urls: [image])
//        }
//        print("Image urls: \(String(describing: files))")
//        getResponse(useAlamofire: true, .post, endPoint: EndPoint.profileUpdateApi.rawValue, parameters: parameters, isMultiPartData: .multiPartFormData, files: files, completion: completion)
//    }
    
//    func getProfileApi(completion: @escaping (Result<(UserResponse?, Int?), Error>) -> ()) {
//        var parameters: [String: Any] = [:]
//        if let userId = appUserData?.id{
//            parameters.updateValue(userId, forKey: "user_id")
//        }
//        getResponse(.post, endPoint: EndPoint.getProfileApi.rawValue, parameters: parameters, completion: completion)
//    }
    
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]?, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: UserResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                completion(.success((data, json, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                appErrorHandler.handleErrorWithFailureCase(error: error, completion: completion)
            }
        }
    }
    
}

class VerifyReAuthService: ServicesDelegate {
    
    func verifyOtpApi(email: String?, otp: String?, completion: @escaping (Result<(VerifyOtpResponse?, [String: Any], Int?), Error>) -> ()) {
        var params: [String: Any] = [:]
        if let email, email != "" {
            params.updateValue(email, forKey: "email")
        }
        if let otp, otp != "" {
            params.updateValue(otp, forKey: "otp")
        }
        getResponse(.post, endPoint: EndPoint.verifyOtpApi.rawValue, parameters: params, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]?, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(VerifyOtpResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: VerifyOtpResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                completion(.success((data, json, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                appErrorHandler.handleErrorWithFailureCase(error: error, completion: completion)
            }
        }
    }
    
}

class ReAuthService: ServicesDelegate {
    
    func forgotPasswordApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        var params: [String: Any] = [:]
        if let email, email != "" {
            params.updateValue(email, forKey: "email")
        }
        getResponse(.post, endPoint: EndPoint.forgotPasswordApi.rawValue, parameters: params, completion: completion)
    }
    
    func resendOtpApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        var params: [String: Any] = [:]
        if let email, email != "" {
            params.updateValue(email, forKey: "email")
        }
        getResponse(.post, endPoint: EndPoint.resendOtpApi.rawValue, parameters: params, completion: completion)
    }
    
    func resetPasswordApi(resetToken: String?, newPassword: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        
        /*
         {
           "resetToken": "mi62ah97l5nu9i4f26te",
           "newPassword": "Test@123"
         }
         */
        var params: [String: Any] = [:]
        if let resetToken, resetToken != "" {
            params.updateValue(resetToken, forKey: "resetToken")
        }
        if let newPassword, newPassword != "" {
            params.updateValue(newPassword, forKey: "newPassword")
        }
        getResponse(.post, endPoint: EndPoint.resetPasswordApi.rawValue, parameters: params, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]?, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: GeneralResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                completion(.success((data, json, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                appErrorHandler.handleErrorWithFailureCase(error: error, completion: completion)
            }
        }
    }
    
}
