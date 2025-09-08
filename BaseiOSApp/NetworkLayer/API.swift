//
//  API.swift
//  rebox
//
//  Created by Waqas Ashraf on 13/03/2024.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
//import Alamofire

var appErrorHandler: AppErrorHandler = AppErrorHandler()

enum AppSpecificError: Error {
    case cannotConvertToHttpReponse
    case cannotParseData(_ statusCode: Int, _jsonObj: [String: Any])
//    case networkError(_ errorMessage: String, _ errorCode: Int)
}

extension AppSpecificError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotConvertToHttpReponse:
            return NSLocalizedString("Error converting httpResponse to HTTPURLResponse", comment: "PlexaarSpecificError")
        case .cannotParseData:
            return NSLocalizedString("Cannot read data", comment: "PlexaarSpecificError")
        }
    }
}

let del = UIApplication.shared.delegate as! AppDelegate


//Preprod
//let baseUrlDomain = "https://plexaargateway-preprod.findanexpert.net"
let baseUrlDomain = "https://api.fortheloveofmahjongg.com/api"
let socketUrlDomain = ""

//Staging
let baseUrl = "\(baseUrlDomain)"
//Live
//let baseUrl = "\(baseUrlEndPoint)\(ConnectingRouteEndPoints.api.rawValue)"
//Image baseUrl
let imageBaseUrl = "\(baseUrlDomain)"

enum RequestType: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum ParameterType{
    case multiPartFormData
}

struct FileParameters{
    var fileName: String
    var urls: [URL]
}

//MARK: - API
class API: APIServiceDelegate {
    
    static let shared = API()
    
    func downloadApi(endpoint: String, fileType: String? = nil, completion: @escaping (Result<(URL, HTTPURLResponse), Error>)->()){
        
        guard let inputUrl = URL(string: endpoint) else { return }
        let request = URLRequest(url: inputUrl)
        CacheManager.shared.getFileWith(stringUrl: endpoint, fileType: fileType) { result in
            
            switch result {
            case .success(let url):
                // do some magic with path to saved video
                print("Media already exists: \(url)")
                completion(.success((url, HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))))
            case .failure(_):
                // handle errror
                print("Download Media")
                URLSessionMaker.shared.downloadApiCall(request: request, completion: completion)
            }
        }
        
    }
    
    // API call
    func api<T: Codable>(useAlamofire: Bool = false, type: RequestType? = nil, ignoreBaseUrl: Bool = false, endpoint: String, parameters: [String: Any]? = nil, customHeaders: [String: String]? = nil, urlSessionConfiguration: URLSessionConfiguration? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, expecting: T.Type, completion: @escaping (Result<(T, [String: Any], HTTPURLResponse), Error>)->()){
        
        
        guard let request = UrlRequestMaker.makeRequest(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endpoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files) else{
            
            //For debugging
            AppLogger.error("Some issue occured while creating request")
            
            return
        }
        
        //URL Session Configuration
        var config: URLSessionConfiguration = URLSessionConfiguration.default
        
        if let urlSessionConfiguration{
            config = urlSessionConfiguration
        }
        else{
            ///`false`: Cancels the request if the internet connect goes away
            config.waitsForConnectivity = false
            
            ///Time out setting if response takes more than 10 seconds
            config.timeoutIntervalForResource = 10
        }
        
        config.httpAdditionalHeaders = ["Accept": "application/json"]
        
        if useAlamofire {
            //Temp disabled
            /*
             AlamofireApiManager.shared.alamofireApiCall(type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endpoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, request: request, expecting: expecting, completion: completion)
             */
            
        }
        else {
            // Using url session to hit end-point
            URLSessionMaker.shared.apiCall(request: request, urlSessionConfiguration: config, expecting: expecting, completion: completion)
        }
        
        
    }
     
}

//MARK: UrlRequestMaker
class UrlRequestMaker{
    
    class func makeRequest(type: RequestType? = nil, ignoreBaseUrl: Bool = false, endpoint: String, parameters: [String: Any]? = nil, customHeaders: [String: String]? = nil,isMultiPartData: ParameterType? = nil, rawData: String?, files: FileParameters? = nil) -> URLRequest?{
        
        let boundary = String(format: "net.3lvis.networking.%08x%08x", arc4random(), arc4random())
        
        var requestType = ""
        
        guard let url: URL = URL(string: ignoreBaseUrl ? endpoint : baseUrl + endpoint) else{
            return nil
        }
        var request = URLRequest(url: url)
        
        
        /*
         
         
         //Setting Language
         if let selectedLanguage = selectedLanguage {
             request.addValue(selectedLanguage, forHTTPHeaderField: "language")
         }
         
         //Setting device token
         request.addValue(del.deviceId, forHTTPHeaderField: "user-agent")
         
         //Setting Time Zone Header
         request.addValue(TimeZone.current.identifier, forHTTPHeaderField: "timezone")
         
         */
        
        //Getting token & selected language
//        let selectedLanguage = appSelectedLanguage
        
        //Setting token
        if let token = appAuthToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: HttpHeaderKey.authorization.rawValue)
        
//            request.addValue("Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTQ4MDg5NDYsImlzcyI6IklTU1VFUl9FWFBFUlQiLCJhdWQiOiJQTEVYQUFSIiwiVXNlciI6ImV5SjFjMlZ5U1dRaU9pSTNOamdpTENKbGJXRnBiQ0k2SW5GaGRHVnpkR0ZqWTI5MWJuUTJNVGt4T1VCNWIzQnRZV2xzTG1OdmJTSXNJbkp2YkdVaU9pSlBkMjVsY2lJc0luVnpaWEpFWVhSaElqb2lVRXhGV0VGQlVpSjkifQ.I8ZPi7VWoTK2TxPiAua9xUgaGSrg7f_bsZw8w77pqTqPYJ1VAWzF6zzHAvwRG_aCv-sFMoOu7p8Kf64dRXchYn4RxN1lT6llP5k19B90-x84qDDJcWSShWThS4asvDRDRw9qXHmD6frN5J8Td4DB_vBAz6gbXDdtOvt_9lKMP_BRwbIUSQ0QKG3dQZGRaK9ivcH_8U3L0b3yoCQpYJ_kx3hKZzLJdAUQDlIBMEYVtZF2jT6vXMnGOdvnaaWw-a8FL4Wjax8rf01FQ1CAshQ6d7nMXb2tHa20ZmoJXDkV2LwteHGPhnUphgBT0IFHXW5hufYlBBnO3AmLFHdwz26IQQ", forHTTPHeaderField: HttpHeaderKey.authorization.rawValue)
        }
        
        request.addValue("EmbUNYpVwNmmUluogVIiLXK5HwcWY1Oxza7+HfCcDDE=", forHTTPHeaderField: "userId")
        request.addValue("uKWMxf6fL5gc/ShatIIwFN7pPzDcwmt/BO1sSPSn/JkwxjFp9/6QzRA2GvIvC0LSdXz+X/MPZXw/zHF3htUq0g==", forHTTPHeaderField: "DeviceId")
        //Setting language
//        if let selectedLanguage{
//            request.addValue(selectedLanguage.symbol, forHTTPHeaderField: HttpHeaderKey.language.rawValue)
//        }
//        else{
//            request.addValue("en", forHTTPHeaderField: HttpHeaderKey.language.rawValue)
//        }
        
        //Setting Custom Header
        if let customHeaders = customHeaders {
            for (key, value) in customHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            //For debugging
            AppLogger.network("Custom header is: \(customHeaders)")
        }
        
        //App Version & platform headers
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            AppLogger.all("App version: \(appVersion)")
            request.addValue(appVersion, forHTTPHeaderField: "ios-version")
            request.addValue("ios", forHTTPHeaderField: "platform")
        }
        
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Setting request type
        switch type {
        case .post, .put, .delete, .patch, .get:
            requestType = type?.rawValue ?? .init()
        case .none:
            requestType = "GET"
        }
        
        request.httpMethod = requestType
        
        //For debugging
        AppLogger.network("Request type is: \(requestType)")
        AppLogger.network("Endpoint is: \(url.absoluteString)")
//        Logger.network("Current token: \(String(describing: token))")
        AppLogger.network("Parameters are: \(String(describing: parameters))")
        AppLogger.network("Time Zone is: \(String(describing: TimeZone.current.identifier))")
        
        AppLogger.network("Raw data inside API call is: \(rawData ?? "")")
        
        if requestType != "GET"{
            
            
            if isMultiPartData != nil{
                // if it is Multipart form data
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                //Form data Body & Request Maker
                let bodyData = MultiPartRequestBodyHandler.setUrlRequest(parameters: parameters, urls: files, boundary: boundary)
                
                request.httpBody = bodyData
                
            }
            else{
                
                do {
                    if let rawData{
//                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.httpBody = rawData.data(using: .utf8)
                    }
                    else{
                        // if it is json data
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = try JSONSerialization.data(withJSONObject: parameters ?? .init())
                    }
                } catch let error {
                    AppLogger.error(error.localizedDescription)
                }
            }
            
        }
        
        return request
        
    }
    
}


//MARK: - URLSessionMaker
class URLSessionMaker{
    
    static let shared = URLSessionMaker()
    
    func downloadApiCall(request: URLRequest, completion: @escaping (Result<(URL, HTTPURLResponse), Error>)->()){
        let downloadTask = URLSession.shared.downloadTask(with: request) { url, response, error in
            print("Download Task complete.")
            if let response = response, let url = url,
               let data = try? Data(contentsOf: url) {
                completion(.success((url, response as! HTTPURLResponse)))
                print("Download response: \(response)\nDownload url: \(url)")
            }
            if let error{
                print("Download error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        downloadTask.resume()
    }

    func apiCall<T: Codable>(request: URLRequest, urlSessionConfiguration: URLSessionConfiguration, expecting: T.Type,completion: @escaping (Result<(T, [String: Any], HTTPURLResponse), Error>)->()){
        
//        AppLogger.network("All API headers are: \(String(describing: request.allHTTPHeaderFields))")

        // Using url session to hit end-point
        let task = URLSession(configuration: urlSessionConfiguration).dataTask(with: request) { data, resp, error in
            
            // Reading status code For debugging
            AppLogger.all("Parse response is: \(resp as Any)")
            
            //For debugging
            LogApiResponse.shared.logApiResponse(inputData: data, endPoint: request.url?.absoluteString ?? "", response: resp)
            
            //MARK: NetworkErrorHandling
            if let networkError = error as? URLError{
                
                DispatchQueue.main.async {
                    ActivityIndicator.shared.removeActivityIndicator()
                }
                
                AppLogger.network("Network error code: \(networkError.code.rawValue), Info: \(networkError.localizedDescription)")
                DispatchQueue.main.async {
                    GenericToast.showToast(message: networkError.localizedDescription)
                }
                completion(.failure(networkError))
            }
            
            if let httpResponse = resp as? HTTPURLResponse {
                
                //Handle session
                self.checkAuthorization(statusCode: httpResponse.statusCode)
            }
            
            guard let data = data, let resp = resp else {
                return
            }
            
            let decodedJson = ParsingHandler.shared.decodeDataToJson(data: data)
            
            do {
                
                // Decode/Parse data
                let decodedResult = try ParsingHandler.shared.parser(data: data, expected: expecting)
                
                //Return Decoded result
                completion(.success((decodedResult, decodedJson, (resp as! HTTPURLResponse))))

            }
            catch {
                
                //For debugging
                let response = resp as! HTTPURLResponse
                AppLogger.error("Error response is: \(response), Error other respone: \(resp)")
                //Remove Progress bar
                DispatchQueue.main.async {
                    ActivityIndicator.shared.removeActivityIndicator()
                }
                //Show parsing error toast
                DispatchQueue.main.async {
                    GenericToast.showToast(message: "\(response.statusCode): \(error.localizedDescription)")
                }
                
                let parsingError: AppSpecificError = .cannotParseData(response.statusCode, _jsonObj: decodedJson)
                
                //Return error
                completion(.failure(parsingError))
            }
        }
        task.resume()
        
        AppLogger.network("All API headers are: \(String(describing: task.currentRequest?.allHTTPHeaderFields))")
        
    }
    
    //MARK: Check authorization
    
    private func checkAuthorization(statusCode: Int){
        DispatchQueue.main.async {
            guard !UnAuthorizationHandler.isUnAuthorizationErrorCode(statusCode, isFirst: false) else {
                return
            }
        }
    }
    
}

//MARK: AlamofireApiManager
class AlamofireApiManager {
    
    private init(){}
    
    static let shared: AlamofireApiManager = AlamofireApiManager()
    
    //Temp disabled
    /*
     func alamofireApiCall<T: Codable>(type: RequestType? = nil, ignoreBaseUrl: Bool = false, endpoint: String, parameters: [String: Any]? = nil, customHeaders: [String: String]? = nil, urlSessionConfiguration: URLSessionConfiguration? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, expecting: T.Type, completion: @escaping (Result<(T, [String: Any], HTTPURLResponse), Error>)->()) {
         
         let url = ignoreBaseUrl ? endpoint : baseUrl + endpoint
         var allHeaders: HTTPHeaders = [.accept("application/json")]
         var method: HTTPMethod = .get
         //Setting token
         if let token = appAuthToken{
             allHeaders.add(.authorization(bearerToken: token))
         }
         
         if let customHeaders {
             for customHeader in customHeaders {
                 allHeaders.add(name: customHeader.key, value: customHeader.value)
             }
         }
         
         // Setting request type
         switch type {
         case .post:
             method = .post
         case .put:
             method = .put
         case .delete:
             method = .delete
         case .patch:
             method = .patch
         case .get, nil:
             method = .get
         }
         
         //Don't use this
 //        let alamofireRequest = AF.request(request)
         
         //Use this
         var alamofilreRequest: DataRequest = AF.request(url, method: method, parameters: parameters, headers: allHeaders)
         
         if let isMultiPartData, isMultiPartData == .multiPartFormData {
             alamofilreRequest = AF.upload(multipartFormData: { formData in
                 let boundary = formData.boundary
                 for (index, file) in (files?.urls ?? []).enumerated() {
                     formData.append(file, withName: files?.fileName ?? "file\(index+1)")
                 }
                 if let parameters{
                     parameters.forEach { (key, value) in
                         formData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                     }
                 }
             }, to: url, method: method, headers: allHeaders)
         }
         
        //Use this
     alamofilreRequest.responseData { [weak self] response in
         let result = response.result
         let httpResponse = response.response
         
         //For debugging
         LogApiResponse.shared.logApiResponse(inputData: response.data, endPoint: endpoint, response: response.response)
         
         if let httpResponse {
             //Handle session
             self?.checkAuthorization(statusCode: httpResponse.statusCode)
         }
         
         guard let httpResponse else {
             
             //Remove Progress bar
             DispatchQueue.main.async {
                 ActivityIndicator.shared.removeActivityIndicator()
             }
             
             //Show parsing error toast
             GenericToast.showToast(message: "Couldn't get response")
             
             completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
             
             return
             
         }
         
         switch result {
         case .success(let data):
             
             let decodedJson = ParsingHandler.shared.decodeDataToJson(data: data)
             
             do {
                 
                 // Decode/Parse data
                 let decodedResult = try ParsingHandler.shared.parser(data: data, expected: expecting)
                 
                 //Return Decoded result
                 completion(.success((decodedResult, decodedJson, httpResponse)))

             }
             catch {
                 
                 
                 //For debugging
                 AppLogger.error("Error response is: \(httpResponse), Error: \(error.localizedDescription)")
                 //Remove Progress bar
                 DispatchQueue.main.async {
                     ActivityIndicator.shared.removeActivityIndicator()
                 }
                 //Show parsing error toast
                 DispatchQueue.main.async {
                     GenericToast.showToast(message: "\(httpResponse.statusCode): \(error.localizedDescription)")
                 }
                 
                 let parsingError: AppSpecificError = .cannotParseData(httpResponse.statusCode, _jsonObj: ["custom_error": "Cannot Parse 💔💔💔💔"])
                 
                 //Return error
                 completion(.failure(parsingError))
             }
             
         case .failure(let failure):
             //Remove Progress bar
             DispatchQueue.main.async {
                 ActivityIndicator.shared.removeActivityIndicator()
             }
             
             //Show parsing error toast
             GenericToast.showToast(message: "\(httpResponse.statusCode): \(failure.localizedDescription)")
             
             completion(.failure(failure))
         }
     }
     
        //Don't use this
     /*
      alamofilreRequest.responseDecodable(of: expecting) { [weak self] response in
          let result = response.result
          let httpResponse = response.response
          
          // Reading status code For debugging
          AppLogger.all("Parse response is: \(response as Any)")
          
          //For debugging
          LogApiResponse.shared.logApiResponse(inputData: response.data, endPoint: endpoint, response: response.response)
          
          if let httpResponse {
              //Handle session
              self?.checkAuthorization(statusCode: httpResponse.statusCode)
          }
          
          guard let httpResponse else {
              
              //Remove Progress bar
              DispatchQueue.main.async {
                  ActivityIndicator.shared.removeActivityIndicator()
              }
              
              //Show parsing error toast
              GenericToast.showToast(message: "Couldn't get response")
              
              completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
              
              return
          }
          
          switch result {
          case .success(let success):
              completion(.success((success, httpResponse)))
          case .failure(let failure):
              
              //Remove Progress bar
              DispatchQueue.main.async {
                  ActivityIndicator.shared.removeActivityIndicator()
              }
              
              //Show parsing error toast
              GenericToast.showToast(message: "\(httpResponse.statusCode): \(failure.localizedDescription)")
              
              completion(.failure(failure))
          }
      }
      */
         
         
     }
     
     //MARK: Check authorization
     
     private func checkAuthorization(statusCode: Int){
         DispatchQueue.main.async {
             guard !UnAuthorizationHandler.isUnAuthorizationErrorCode(statusCode, isFirst: false) else {
                 return
             }
         }
     }
     */
    
    
    
}

//MARK: - MultiPartRequestBodyHandler
class MultiPartRequestBodyHandler{
    
    static func setUrlRequest(parameters: [String: Any]?, urls: FileParameters?, boundary: String) -> Data?{
        
        print("File urls: \(String(describing: urls))")
        
        var data: Data?
        
        if let parameters{
            data = Data()
            parameters.forEach { (key, value) in
                data?.append("--\(boundary)\r\n")
                data?.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                data?.append("\(value)\r\n")
            }
        }
        
        
        if let urls = urls{
            for url in urls.urls {
                let filename = url.lastPathComponent
                do {
                    if data == nil{
                        data = Data()
                    }
                    let fileData = try Data(contentsOf: url)
                    data?.append("--\(boundary)\r\n")
                    data?.append("Content-Disposition: form-data; name=\"\(urls.fileName)\"; filename=\"\(filename)_\(Date().millisecondsSince1970.description)\"\r\n")
                    
                    //Setup Content-Type using ContentTypeHandler
                    let contentType = ContentTypeHandler.setContentType(fileUrl: url)
                    data?.append("Content-Type: \(contentType)\r\n\r\n")
                    
                    //For debugging
//                    AppLogger.network("Mime/Content type is: \(contentType), file name is: \(urls.fileName)")
                    
                    data?.append(fileData)
                    data?.append("\r\n")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        data?.append("--\(boundary)--\r\n")
        
        return data
    }
    
}

//MARK: - ParsingHandler
class ParsingHandler{
    
    static let shared = ParsingHandler()
    
    func parser<T: Codable>(data: Data, expected: T.Type) throws -> T{
        
        let result = try JSONDecoder().decode(expected, from: data)
        return result
        
    }
    
    func encodeItem<T: Codable>(item: T) -> Data?{
        do {
            let encoded = try JSONEncoder().encode(item)
            AppLogger.info("Encoded successfully \(encoded)")
            return encoded
        } catch  {
            AppLogger.error("Encoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func encodeAnyItem(item: [String: Any]) -> Data?{
        do {
            let encodedData = try JSONSerialization.data(withJSONObject: item)
            AppLogger.info("Encoded successfully \(encodedData)")
            return encodedData
        } catch {
            AppLogger.error("Encoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func decodeDictionary<T: Codable>(data: [String: Any], expected: T.Type) -> T? {
        guard let encodedData = ParsingHandler.shared.encodeAnyItem(item: data) else { return nil }
        do {
            let decodedData =  try ParsingHandler.shared.parser(data: encodedData, expected: expected)
            print("Decoded routeDeviation data: \(decodedData)")
            return decodedData
        } catch  {
            print("error decoding route deviation data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func decodeDataToJson(data: Data) -> [String: Any] {
        if let parsedJsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            // Serialize to JSON
//            let jsonData = try? JSONSerialization.data(withJSONObject: parsedJsonData)
            
            return parsedJsonData
            
        }
        else {
            return ["custom_error": "Cannot Parse 💔💔💔💔"]
        }
    }
    
}

//MARK: - ContentTypeHandler
class ContentTypeHandler{
    
    static func setContentType(fileUrl: URL) -> String{
        
        let mimeTypes = Bundle.main.path(forResource: "mimeTypes", ofType: "json")
        let typeName = fileUrl.pathExtension
        
        if let mimeTypes = mimeTypes{
            let mimeData = NSData(contentsOfFile: mimeTypes) as? Data
            if let mimeData = mimeData{
                
                do {
                    let contentTypes = try ParsingHandler.shared.parser(data: mimeData, expected: [ContentType].self)
                    for contentType in contentTypes{
                        
                        //For debugging
                        AppLogger.all("Content type is: \(contentType)")
                        AppLogger.all("File type is: \(typeName), content name is: \(contentType.name)")
                        
                        if typeName == contentType.name{
                            
                            //for debugging
                            AppLogger.all("The file's content type is: \(String(describing: contentType.template))")
                            
                            //Return mimeType/Content-Type,  e.g: image/png, video/3gpp, text/html
                            return contentType.template
                        }
                    }
                } catch {
                    //For debugging
                    AppLogger.error("Content type json parsing error: \(error.localizedDescription)")
                    
                    return "application/octet-stream"
                }
            }
            else{
                return "application/octet-stream"
            }
        }
        else{
            return "application/octet-stream"
        }
        return "application/octet-stream"
    }
    
}

//MARK: - Data Extension
extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

//MARK: - URL Extension
extension URL {
    /// Mime type for the URL
    ///
    /// Requires `import UniformTypeIdentifiers` for iOS 14 solution.
    /// Requires `import MobileCoreServices` for pre-iOS 14 solution

    var mimeType: String {
        if #available(iOS 14.0, *) {
            return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
        } else {
            guard
                let identifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
                let mimeType = UTTypeCopyPreferredTagWithClass(identifier, kUTTagClassMIMEType)?.takeRetainedValue() as String?
            else {
                return "application/octet-stream"
            }

            return mimeType
        }
    }
}

struct ContentType: Codable{
    
    let name, template, refrence: String
    
    enum CodingKeys: String, CodingKey{
        case name = "Name"
        case template = "Template"
        case refrence = "Reference"
    }
    
}

public enum CacheResult<T> {
    case success(T)
    case failure(NSError)
}

//MARK: LogResponse
class LogApiResponse{
    
    static let shared: LogApiResponse = LogApiResponse()
    
    func logApiResponse(inputData: Data?, endPoint: String, response: URLResponse?){
        
        var statusCode: String = ""
        if let httpResponse = response as? HTTPURLResponse{
            statusCode += " with Status Code: \(httpResponse.statusCode)"
        }
        let str = "API \(endPoint)\(statusCode) Response 💚💚💚💚 \n"
        var finalLog: String = "\(str)"
        
        if let inputData {
            if let parsedJsonData = try? JSONSerialization.jsonObject(with: inputData, options: []) as? [String: Any] {
                
                // Serialize to JSON
                let jsonData = try? JSONSerialization.data(withJSONObject: parsedJsonData)
                
                // Convert to a string and print
                if let JSONString = String(data: jsonData ?? Data(), encoding: String.Encoding.utf8) {
                    finalLog += " \(JSONString)"
                }
            }
            else {
                let htmlResponse = inputData.html2String
                finalLog += " \(htmlResponse)"
            }
        }
        
        AppLogger.api(finalLog)
        
    }
}

//MARK: ManageCache
class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    func getFile(stringUrl: String, fileType: String? = nil) -> URL?{
        let file = directoryFor(stringUrl: stringUrl, fileType: fileType)
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            return file
        }
        
        return nil
    }

    func getFileWith(stringUrl: String, fileType: String? = nil, completionHandler: @escaping (CacheResult<URL>) -> Void ) {


        let file = directoryFor(stringUrl: stringUrl, fileType: fileType)

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(CacheResult.success(file))
            return
        }

        DispatchQueue.global().async {

            if var fileData = NSData(contentsOf: URL(string: stringUrl)!) {
                
                //Prepare Wav file header - for later use
//                if fileType == "wav"{
//                    let waveHeaderFormat = self.createWaveHeader(data: fileData as Data) as Data
//                    fileData = (waveHeaderFormat + fileData) as NSData
//                }
                
                fileData.write(to: file, atomically: true)
                DispatchQueue.main.async {
                    completionHandler(CacheResult.success(file))
                }
            }
            else {
                DispatchQueue.main.async {
                    completionHandler(CacheResult.failure(NSError(domain: "Can't download video", code: 619)))
                }
            }
        }
    }

    private func directoryFor(stringUrl: String, fileType: String? = nil) -> URL {

        let fileURL = URL(string: stringUrl)!.lastPathComponent
        print("File path to be saved: \(fileURL)")
        if let fileType{
            print("Change File path change to: \(fileURL).\(fileType)")
            let file = self.mainDirectoryUrl.appendingPathComponent("\(fileURL).\(fileType)")
            return file
        }
        else{
            let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)
            return file
        }
    }
    
    private func createWaveHeader(data: Data) -> NSData {
        
        let sampleRate:Int32 = 2000
        let chunkSize:Int32 = 36 + Int32(data.count)
        let subChunkSize:Int32 = 16
        let format:Int16 = 1
        let channels:Int16 = 1
        let bitsPerSample:Int16 = 8
        let byteRate:Int32 = sampleRate * Int32(channels * bitsPerSample / 8)
        let blockAlign: Int16 = channels * bitsPerSample / 8
        let dataSize:Int32 = Int32(data.count)
        
        let header = NSMutableData()
        
        header.append([UInt8]("RIFF".utf8), length: 4)
        header.append(intToByteArray(chunkSize), length: 4)
        
        //WAVE
        header.append([UInt8]("WAVE".utf8), length: 4)
        
        //FMT
        header.append([UInt8]("fmt ".utf8), length: 4)
        
        header.append(intToByteArray(subChunkSize), length: 4)
        header.append(shortToByteArray(format), length: 2)
        header.append(shortToByteArray(channels), length: 2)
        header.append(intToByteArray(sampleRate), length: 4)
        header.append(intToByteArray(byteRate), length: 4)
        header.append(shortToByteArray(blockAlign), length: 2)
        header.append(shortToByteArray(bitsPerSample), length: 2)
        
        header.append([UInt8]("data".utf8), length: 4)
        header.append(intToByteArray(dataSize), length: 4)
        
        return header
    }
    
    private func intToByteArray(_ i: Int32) -> [UInt8] {
        return [
            //little endian
            UInt8(truncatingIfNeeded: (i      ) & 0xff),
            UInt8(truncatingIfNeeded: (i >>  8) & 0xff),
            UInt8(truncatingIfNeeded: (i >> 16) & 0xff),
            UInt8(truncatingIfNeeded: (i >> 24) & 0xff)
        ]
    }
    
    private func shortToByteArray(_ i: Int16) -> [UInt8] {
        return [
            //little endian
            UInt8(truncatingIfNeeded: (i      ) & 0xff),
            UInt8(truncatingIfNeeded: (i >>  8) & 0xff)
        ]
    }
    
}

//MARK: AppErrorHandler
class AppErrorHandler {
    
    func handleErrorWithSuccessCase<T: Codable>(error: Error, expecting: T, completion: @escaping (Result<(T?, [String: Any], Int?), Error>) -> ()) {
        if let mutableError = error as? AppSpecificError {
            
            switch mutableError {
            case .cannotConvertToHttpReponse:
                completion(.success((expecting, [:], -1)))
            case .cannotParseData(let statusCode, _jsonObj: let jsonObj):
                completion(.success((expecting, jsonObj, statusCode)))
            }
            
        }
        else {
            completion(.success((expecting, [:], -1)))
        }
    }
    
    func handleErrorWithFailureCase<T: Codable>(error: Error, completion: @escaping (Result<(T?, [String: Any], Int?), Error>) -> ()) {
        
        if let mutableError = error as? AppSpecificError {
            
            completion(.failure(mutableError))
            
        }
        else {
            completion(.failure(error))
        }
    }
    
    func displayError(_ error: Error) {
        if let error = error as? AppSpecificError{
            switch error {
            case .cannotConvertToHttpReponse:
                print("Error: 💔💔💔💔 \(error.localizedDescription)")
            case .cannotParseData(let statusCode, let json):
                print("Error: 💔💔💔💔 \(error.localizedDescription) -> StatusCode: \(statusCode)")
            }
        }
        else{
            print("Error: 💔💔💔💔 \(error.localizedDescription)")
        }
    }
    
}

//MARK: QueryParamMaker
class QueryParamMaker {
    
    static func makeQueryParam(params: [String]?) -> String{
        var queryParams: String = ""
        if let params {
            for (index, param) in params.enumerated() {
                let connectingSymbol: String = index == 0 ? "?" : "&"
                queryParams += "\(connectingSymbol)\(param)"
            }
        }
        return queryParams
    }
    
    static func makeQueryParamV2(params: [String]?) -> String{
        var queryParams: String = ""
        if let params {
            for (index, param) in params.enumerated() {
                let connectingSymbol: String = ""
                queryParams += "\(connectingSymbol)\(param)"
            }
        }
        return queryParams
    }
    
    static func makeEncryptedQueryParamString(paramString: String?) -> String {
        var queryParams: String = ""
        if let paramString {
            queryParams += "?enc=\(paramString)"
        }
        return queryParams
    }
    
}

//MARK: HTMLParser
extension Data {
    
    var html2AttributedString: NSAttributedString? {
        
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
    
}
extension StringProtocol {
    
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
    
}
