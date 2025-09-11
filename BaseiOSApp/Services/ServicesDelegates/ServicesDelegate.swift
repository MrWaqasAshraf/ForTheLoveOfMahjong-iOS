//
//  ServicesDelegate.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

protocol ServicesDelegate {
    
    associatedtype GenericTypeOne
    associatedtype GenericTypeTwo
    associatedtype GenericTypeThree
    
    func loginApi(email: String?, password: String?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ())
    func signUpApi(parameters: [String: Any]?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ())
    func createEventApi(parameters: [String: Any]?, images: [URL]?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ())
    func updateEventApi(parameters: [String: Any]?, images: [URL]?, eventId: Int?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ())
    func dashboardEventsApi(filters: [String]?, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ())
    func mahjongEventDetailApi(eventId: String?, completion: @escaping (Result<(MahjongEventDetailResponse?, [String: Any], Int?), Error>) -> ())
    func forgotPasswordApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ())
    func resendOtpApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ())
    func resetPasswordApi(payload: [String: Any]?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ())
    func verifyOtpApi(email: String?, otp: String?, completion: @escaping (Result<(VerifyOtpResponse?, [String: Any], Int?), Error>) -> ())
    
    //MARK: Test APIs
    func businessListApi(userId: Int?, pageNo: Int?, pageSize: Int?, dynamicListing: BooleanCustomEnum?, completion: @escaping (Result<(BusinessListResponse?, [String: Any], Int?), Error>) -> ())
    func dashboardApi(businessId: Int?, pageNo: Int?, pageSize: Int?, dateFilter: String?, completion: @escaping (Result<(DashboardResponse?, [String: Any], Int?), Error>) -> ())
    func staffDetailApi(businessId: Int?, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ())
    
    
    //MARK: - GetResponse
    func getResponse(useAlamofire: Bool, _ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, completion: @escaping (Result<(GenericTypeOne?, GenericTypeTwo, GenericTypeThree?), Error>)->())
    
}

extension ServicesDelegate {
    
    func loginApi(email: String?, password: String?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default loginApi implementation")
    }
    
    func signUpApi(parameters: [String: Any]?, completion: @escaping (Result<(UserResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default signUpApi implementation")
    }
    
    func createEventApi(parameters: [String: Any]?, images: [URL]?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default createEventApi implementation")
    }
    
    func updateEventApi(parameters: [String: Any]?, images: [URL]?, eventId: Int?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default updateEventApi implementation")
    }
    
    func dashboardEventsApi(filters: [String]?, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ())  {
        print("Default dashboardEventsApi implementation")
    }
    
    func mahjongEventDetailApi(eventId: String?, completion: @escaping (Result<(MahjongEventDetailResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default mahjongEventDetailApi implementation")
    }
    
    func forgotPasswordApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default forgotPasswordApi implementation")
    }
    
    func resendOtpApi(email: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default resendOtpApi implementation")
    }
    
    func resetPasswordApi(payload: [String: Any]?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default resetPasswordApi implementation")
    }
    
    func verifyOtpApi(email: String?, otp: String?, completion: @escaping (Result<(VerifyOtpResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default resendOtpApi implementation")
    }
    
    //MARK: Test APIs
    func businessListApi(userId: Int?, pageNo: Int?, pageSize: Int?, dynamicListing: BooleanCustomEnum?, completion: @escaping (Result<(BusinessListResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default businessListApi implementation")
    }
    
    func dashboardApi(businessId: Int?, pageNo: Int?, pageSize: Int?, dateFilter: String?, completion: @escaping (Result<(DashboardResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default dashboardApi implementation")
    }
    
    func staffDetailApi(businessId: Int?, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ()) {
        print("Default staffDetailApi implementation")
    }
    
    
    //MARK: - GetResponse
    func getResponse(useAlamofire: Bool, _ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, completion: @escaping (Result<(GenericTypeOne?, GenericTypeTwo, GenericTypeThree?), Error>)->()) {
        print("Default getResponse implementation")
    }
    
}
