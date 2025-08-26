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
    
    func businessListApi(userId: Int?, pageNo: Int?, pageSize: Int?, dynamicListing: BooleanCustomEnum?, completion: @escaping (Result<(BusinessListResponse?, [String: Any], Int?), Error>) -> ())
    func dashboardApi(businessId: Int?, pageNo: Int?, pageSize: Int?, dateFilter: String?, completion: @escaping (Result<(DashboardResponse?, [String: Any], Int?), Error>) -> ())
    func staffDetailApi(businessId: Int?, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ())
    
    
    //MARK: - GetResponse
    func getResponse(_ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, completion: @escaping (Result<(GenericTypeOne?, GenericTypeTwo, GenericTypeThree?), Error>)->())
    
}

extension ServicesDelegate {
    
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
    func getResponse(_ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, completion: @escaping (Result<(GenericTypeOne?, GenericTypeTwo, GenericTypeThree?), Error>)->()) {
        print("Default getResponse implementation")
    }
    
}
