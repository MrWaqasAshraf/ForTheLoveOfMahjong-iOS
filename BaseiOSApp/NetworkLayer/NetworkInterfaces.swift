//
//  NetworkInterfaces.swift
//  rebox
//
//  Created by Waqas Ashraf on 13/03/2024.
//

import Foundation

protocol APIServiceDelegate: AnyObject{
    func api<T: Codable>(useAlamofire: Bool, type: RequestType?, ignoreBaseUrl: Bool, endpoint: String, parameters: [String: Any]?, customHeaders: [String: String]?, urlSessionConfiguration: URLSessionConfiguration?, isMultiPartData: ParameterType?, rawData: String?, files: FileParameters?, expecting: T.Type, completion: @escaping (Result<(T, [String: Any], HTTPURLResponse), Error>)->())
}

protocol UrlRequestMakerDelegate: AnyObject{
    
}
