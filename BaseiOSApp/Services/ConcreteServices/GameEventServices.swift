//
//  GameEventServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/09/2025.
//

import Foundation

class DashboardService: ServicesDelegate {
    
    func dashboardEventsApi(completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ()) {
        getResponse(.get, endPoint: EndPoint.dashboardApi.rawValue, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: MahjongEventsListResponse.self) { result in
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

class ManageMahjongEventsService: ServicesDelegate {
    
    func createEventApi(parameters: [String: Any]?, images: [URL]?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        /*
         {
             "type":"Tournament",
             "name":"Annual Mahjong Championship 2025",
             "dateTime":["Saturday, March 15, 2025 – 10:00 AM", "Saturday, March 15, 2025 – 06:00 PM"],
             "locationName":"Grand Mahjong Hall",
             "address":"123 Tournament Street, Mahjong City, MC 12345",
             "lat":40.7589,
             "lng":-73.9851,
             "category":"Chinese",
             "contact":"+1-555-MAHJONG",
             "description":"Join us for the most exciting Mahjong tournament of the year! Open to all skill levels with multiple prize categories. Professional dealers and equipment provided.",
         }
         */
        var files: FileParameters?
        if let images {
            files = FileParameters(fileName: "Images", urls: images)
        }
        getResponse(.post, endPoint: EndPoint.createEventApi.rawValue, parameters: parameters, isMultiPartData: .multiPartFormData, files: files, completion: completion)
    }
    
    func updateEventApi(parameters: [String: Any]?, images: [URL]?, eventId: Int?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        /*
         {
             "type":"Tournament",
             "name":"Annual Mahjong Championship 2025",
             "dateTime":["Saturday, March 15, 2025 – 10:00 AM", "Saturday, March 15, 2025 – 06:00 PM"],
             "locationName":"Grand Mahjong Hall",
             "address":"123 Tournament Street, Mahjong City, MC 12345",
             "lat":40.7589,
             "lng":-73.9851,
             "category":"Chinese",
             "contact":"+1-555-MAHJONG",
             "description":"Join us for the most exciting Mahjong tournament of the year! Open to all skill levels with multiple prize categories. Professional dealers and equipment provided.",
         }
         */
        var endPoint: String = EndPoint.editEventApi.rawValue
        if let eventId {
            endPoint += "/\(eventId)"
        }
        var files: FileParameters?
        if let images {
            files = FileParameters(fileName: "Images", urls: images)
        }
        getResponse(.post, endPoint: endPoint, parameters: parameters, isMultiPartData: .multiPartFormData, files: files, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        
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
