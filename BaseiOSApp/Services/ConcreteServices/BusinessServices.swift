//
//  BusinessServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

class BusinessInfoService: ServicesDelegate{
    
    func businessListApi(userId: Int?, pageNo: Int?, pageSize: Int?, dynamicListing: BooleanCustomEnum?, completion: @escaping (Result<(BusinessListResponse?, [String: Any], Int?), Error>) -> ()) {
        //?userId=46&dynamicListing=False
        
//        var queryParameters: String = ""
        
        //Actual implementation
        var params: [String] = ["page_size=\(pageSize ?? 20)"]
        if let pageNo {
            params.append("page=\(pageNo)")
        }
        if let userId {
            params.append("userId=\(userId)")
        }
//        if let dynamicListing {
//            params.append("dynamicListing=\(dynamicListing.rawValue)")
//        }
        let queryParameters: String = QueryParamMaker.makeQueryParamV2(params: params)
        let encString = appSecurityManager.aesEncrypt(text: queryParameters)
        let encParams = QueryParamMaker.makeEncryptedQueryParamString(paramString: encString?.convertToCleanEncrptedString())
        //https://plexaargateway-staging.findanexpert.net/business_svc/pv/get_business_list/?userId=532
        
        let endPoint = EndPoint.businessEndpointApi.rawValue + encParams
        getResponse(.get, endPoint: endPoint , completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(BusinessListResponse?, [String: Any], Int?), Error>) -> ()) {
        API.shared.api(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: EncryptionResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
//                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
//                completion(.success((data, resp.statusCode)))
                
                let decrypt = appSecurityManager.decryptWithoutIV(encryptedBase64: data.result ?? "")
                if let stringData = decrypt?.data(using: .utf8) {
                    do {
                       let decodedData = try ParsingHandler.shared.parser(data: stringData, expected: BusinessListResponse.self)
                        completion(.success((decodedData, json, resp.statusCode)))
                    } catch {
                        print("Error parsing: \(error.localizedDescription)")
                        let mutableError: AppSpecificError = .cannotParseData(resp.statusCode, _jsonObj: json)
                        appErrorHandler.handleErrorWithFailureCase(error: mutableError, completion: completion)
                    }
                }
                else {
                    completion(.failure(NSError(domain: "Data nil", code: -1)))
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
