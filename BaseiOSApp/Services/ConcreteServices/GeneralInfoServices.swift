//
//  GeneralInfoServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/09/2025.
//

import Foundation

class FAQsService: ServicesDelegate {
    
    func faqsListApi(pageNo: Int?, pageSize: Int?, completion: @escaping (Result<(FaqsListResponse?, [String: Any], Int?), Error>) -> ()) {
        var params: [String] = []
        if let pageNo {
            params.append("page=\(pageNo)")
        }
        if let pageSize {
            params.append("limit=\(pageSize)")
        }
        let queryParams = QueryParamMaker.makeQueryParam(params: params)
        let endPoint: String = EndPoint.faqsListApi.rawValue + queryParams
        getResponse(.get, endPoint: endPoint, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(FaqsListResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: FaqsListResponse.self) { result in
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
