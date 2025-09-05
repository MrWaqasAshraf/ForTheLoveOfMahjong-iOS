//
//  AttendanceServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

class DashboardTestService: ServicesDelegate {
    
    func dashboardApi(businessId: Int?, pageNo: Int?, pageSize: Int?, dateFilter: String?, completion: @escaping (Result<(DashboardResponse?, [String: Any], Int?), Error>) -> ()) {
        //AttendanceListResponse
        //business_id
        //page_size
        //page_no
        var params: [String] = []
        
        if let pageNo {
            params.append("page=\(pageNo)")
        }
        if let pageSize {
            params.append("pageSize=\(pageSize)")
        }
        if let businessId {
            params.append("businessId=\(businessId)")
        }
        if let dateFilter {
            params.append("date=\(dateFilter)")
        }
        print("Params: \(params)")
        let query = QueryParamMaker.makeQueryParam(params: params)
//        let queryParameters: String = QueryParamMaker.makeQueryParamV2(params: params)
//        let encString = appSecurityManager.aesEncrypt(text: queryParameters)
//        let encParams = QueryParamMaker.makeEncryptedQueryParamString(paramString: encString?.convertToCleanEncrptedString())
        
        getResponse(.get, endPoint: EndPoint.dashboardTestApi.rawValue + query, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(DashboardResponse?, [String: Any], Int?), Error>) -> ()) {
        API.shared.api(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: DashboardResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
//                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(json)")
                var mutableData = data
                let attendanceDetail = mutableData.result?.attendanceDetails?.map({ model in
                    var mutableModel = model
                    mutableModel.setProductiveTime()
                    mutableModel.setTotalBreakTimeTime()
                    return mutableModel
                })
                mutableData.result?.attendanceDetails = attendanceDetail
                completion(.success((mutableData, json, resp.statusCode)))
                
                //                let decrypt = appSecurityManager.decryptWithoutIV(encryptedBase64: data.result ?? "")
                //                if let stringData = decrypt?.data(using: .utf8) {
                //                    do {
                //                       let decodedData = try ParsingHandler.shared.parser(data: stringData, expected: DashboardResponse.self)
                //                        var mutableData = decodedData
                //                        let attendanceDetail = mutableData.result?.attendanceDetails?.map({ model in
                //                            var mutableModel = model
                //                            mutableModel.setProductiveTime()
                //                            mutableModel.setTotalBreakTimeTime()
                //                            return mutableModel
                //                        })
                //                        mutableData.result?.attendanceDetails = attendanceDetail
                //                        completion(.success((mutableData, resp.statusCode)))
                //                    } catch {
                //                        print("Error parsing: \(error.localizedDescription)")
                //                        completion(.failure(error))
                //                    }
                //                }
                //                else {
                //                    completion(.failure(NSError(domain: "Data nil", code: -1)))
                //                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
//                if let mutableError = error as? AppSpecificError {
//                    
//                    switch mutableError {
//                    case .cannotConvertToHttpReponse:
//                        completion(.success((DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: -1), [:], -1)))
//                    case .cannotParseData(let statusCode, _jsonObj: let jsonObj):
//                        completion(.success((DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: statusCode), jsonObj, statusCode)))
//                    }
//                    
//                }
//                else {
//                    completion(.success((DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: -1), [:], -1)))
//                }
                
                appErrorHandler.handleErrorWithSuccessCase(error: error, expecting: DashboardResponse(error: true, result: nil, message: error.localizedDescription, code: -1), completion: completion)
                
            }
        }
    }
    
}

class StaffListService: ServicesDelegate {
    
    func staffListApi(businessId: Int?, pageNo: Int?, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ()) {
        //?id=423&pageNo=1&pageSize=25
        var params: [String] = ["pageSize=25"]
        if let businessId {
            params.append("id=\(businessId)")
        }
        if let pageNo {
            params.append("pageNo=\(pageNo)")
        }
//        let queryParams: String = QueryParamMaker.makeQueryParam(params: params)
        let queryParameters: String = QueryParamMaker.makeQueryParamV2(params: params)
        let encString = appSecurityManager.aesEncrypt(text: queryParameters)
        let encParams = QueryParamMaker.makeEncryptedQueryParamString(paramString: encString?.convertToCleanEncrptedString())
        let endPoint: String = EndPoint.staffListApi.rawValue + encParams
        getResponse(.get, endPoint: endPoint, completion: completion)
    }
    
    func staffDetailApi(businessId: Int?, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ()) {
        //?userId=574&businessId=423
        var params: [String] = []
        if let businessId {
            params.append("businessId=\(businessId)")
        }
//        if let userId = appUserData?.id {
            params.append("userId=768")
//        }
//        let queryParams: String = QueryParamMaker.makeQueryParam(params: params)
        let queryParameters: String = QueryParamMaker.makeQueryParamV2(params: params)
        let encString = appSecurityManager.aesEncrypt(text: queryParameters)
        let encParams = QueryParamMaker.makeEncryptedQueryParamString(paramString: encString?.convertToCleanEncrptedString())
        let endPoint: String = EndPoint.staffByUserAndBusinessId.rawValue + encParams
        getResponse(.get, endPoint: endPoint, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(StaffListResponse?, [String: Any], Int?), Error>) -> ()) {
        API.shared.api(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: EncryptionResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
//                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
//                completion(.success((data, resp.statusCode)))
                
                let decrypt = appSecurityManager.decryptWithoutIV(encryptedBase64: data.result ?? "")
                if let stringData = decrypt?.data(using: .utf8) {
                    do {
                       let decodedData = try ParsingHandler.shared.parser(data: stringData, expected: StaffListResponse.self)
                        completion(.success((decodedData, json, resp.statusCode)))
                    } catch {
                        print("Error parsing: \(error.localizedDescription)")
                        let mutableError: AppSpecificError = .cannotParseData(resp.statusCode, _jsonObj: json)
                        appErrorHandler.handleErrorWithFailureCase(error: mutableError, completion: completion)
                    }
                }
                else {
                    let mutableError: AppSpecificError = .cannotParseData(resp.statusCode, _jsonObj: json)
                    appErrorHandler.handleErrorWithFailureCase(error: mutableError, completion: completion)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                appErrorHandler.handleErrorWithFailureCase(error: error, completion: completion)
            }
        }
    }
    
}
