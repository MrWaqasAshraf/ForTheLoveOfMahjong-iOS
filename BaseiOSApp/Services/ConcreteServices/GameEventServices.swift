//
//  GameEventServices.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/09/2025.
//

import Foundation

class EventsListingService: ServicesDelegate {
    
    func dashboardEventsApi(filters: [String]?, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ()) {
        let queryParams: String = QueryParamMaker.makeQueryParam(params: filters)
        let endPoint: String = EndPoint.dashboardApi.rawValue + queryParams
        getResponse(.get, endPoint: endPoint, customHeaders: [CustomHeaderKeys.a_id.rawValue: a_id], completion: completion)
    }
    
    func eventsListApi(queryParams: [String]?, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ()) {
        let queryParams: String = QueryParamMaker.makeQueryParam(params: queryParams)
        let endPoint: String = EndPoint.eventsListApi.rawValue + queryParams
        getResponse(.get, endPoint: endPoint, customHeaders: [CustomHeaderKeys.a_id.rawValue: a_id], completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(MahjongEventsListResponse?, [String: Any], Int?), Error>) -> ()) {
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        ///`false`: Cancels the request if the internet connect goes away
        config.waitsForConnectivity = false
        
        ///Time out setting if response takes more than 50 seconds
        config.timeoutIntervalForResource = TimeInterval.infinity
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, urlSessionConfiguration: config, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: MahjongEventsListResponse.self) { result in
            switch result {
            case .success((let data, let json, let resp)):
                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
                if let allowedEvents = data.data?.autoApprovalLimit {
                    allowedEventsNumber = allowedEvents
                }
                completion(.success((data, json, resp.statusCode)))
            case .failure(let error):
                print(error.localizedDescription)
                appErrorHandler.handleErrorWithFailureCase(error: error, completion: completion)
            }
        }
    }
    
}

class ManageMahjongEventsService: ServicesDelegate {
    
    func updateEventApi(parameters: [String: Any]?, images: [URL]?, eventId: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
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
            files = FileParameters(fileName: "image", urls: images)
        }
        getResponse(.put, endPoint: endPoint, parameters: parameters, isMultiPartData: .multiPartFormData, files: files, completion: completion)
    }
    
    func eventDeleteRequestApi(eventId: String?, reason: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        var parameters: [String: Any] = [:]
        if let eventId {
            parameters.updateValue(eventId, forKey: "eventId")
        }
        if let reason {
            parameters.updateValue(reason, forKey: "reason")
        }
        getResponse(.post, endPoint: EndPoint.eventDeleteRequestApi.rawValue, parameters: parameters, completion: completion)
    }
    
    func eventDeleteApi(eventId: String?, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        var endPoint: String = EndPoint.eventDeleteApi.rawValue
        if let eventId {
            endPoint += "/\(eventId)"
        }
        getResponse(.delete, endPoint: endPoint, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(GeneralResponse?, [String: Any], Int?), Error>) -> ()) {
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        ///`false`: Cancels the request if the internet connect goes away
        config.waitsForConnectivity = false
        
        ///Time out setting if response takes more than 50 seconds
        config.timeoutIntervalForResource = TimeInterval.infinity
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, urlSessionConfiguration: config, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: GeneralResponse.self) { result in
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

class ReportEventService: ServicesDelegate {
    
    func reportEventApi(eventId: String?, reason: String?, completion: @escaping (Result<(GeneralResponseTwo?, [String: Any], Int?), Error>) -> ()) {
        var parameters: [String: Any] = [:]
        if let eventId {
            parameters.updateValue(eventId, forKey: "eventId")
        }
        if let reason {
            parameters.updateValue(reason, forKey: "reason")
        }
        getResponse(.post, endPoint: EndPoint.reportEventApi.rawValue, parameters: parameters, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(GeneralResponseTwo?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: GeneralResponseTwo.self) { result in
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

class MahjongEventDetailService: ServicesDelegate {
    
    func mahjongEventDetailApi(eventId: String?, completion: @escaping (Result<(MahjongEventDetailResponse?, [String: Any], Int?), Error>) -> ()) {
        var endPoint: String = EndPoint.eventsListApi.rawValue
        if let eventId, eventId != "" {
            endPoint += "/\(eventId)"
        }
        getResponse(.get, endPoint: endPoint, customHeaders: [CustomHeaderKeys.a_id.rawValue: a_id], completion: completion)
    }
    
    func createEventApi(parameters: [String: Any]?, images: [URL]?, completion: @escaping (Result<(MahjongEventDetailResponse?, [String: Any], Int?), Error>) -> ()) {
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
            files = FileParameters(fileName: "image", urls: images)
        }
        getResponse(.post, endPoint: EndPoint.createEventApi.rawValue, parameters: parameters, isMultiPartData: .multiPartFormData, files: files, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(MahjongEventDetailResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: MahjongEventDetailResponse.self) { result in
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

class FavouriteMahjongEventService: ServicesDelegate {
    
    func toggleFavouriteEventApi(eventId: String?, completion: @escaping (Result<(FavouriteInfoResponse?, [String: Any], Int?), Error>) -> ()) {
        var endPoint: String = EndPoint.toggleFavouriteEventApi.rawValue
        if let eventId, eventId != "" {
            endPoint += "/\(eventId)"
        }
        getResponse(.post, endPoint: endPoint, completion: completion)
    }
    
    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool = false, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(FavouriteInfoResponse?, [String: Any], Int?), Error>) -> ()) {
        
        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: FavouriteInfoResponse.self) { result in
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
