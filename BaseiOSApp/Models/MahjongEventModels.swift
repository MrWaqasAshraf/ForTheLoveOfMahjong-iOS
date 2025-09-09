//
//  MahjongEventModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 07/09/2025.
//

import Foundation

// MARK: - MahjongEventsListResponse
struct MahjongEventsListResponse: Codable {
    let success: Int?
    let message: String?
    let data: MahjongDataResult?
}

struct MahjongDataResult: Codable {
    let events: [MahjongEventData]?
}

// MARK: - MahjongEventData
struct MahjongEventData: Codable {
    let id: String?
    let type, name: String?
    let dateTime: [String]?
    let locationName, address: String?
    let lat, lng: Double?
    let category, contact, description: String?
    let image: String?
    let user: UserInfoData?
    let userName, userEmail: String?

    enum CodingKeys: String, CodingKey {
        case type, name, dateTime, locationName, address, lat, lng, category, contact, description, image
        case user = "userId"
        case id = "_id"
        case userName, userEmail
    }
}

struct MahjongDetailResult: Codable {
    let event: MahjongEventData?
}

// MARK: - MahjongEventDetailResponse
struct MahjongEventDetailResponse: Codable {
    let success: Int?
    let message: String?
    let data: MahjongDetailResult?
    
    var isSuccessful: Bool {
        var isSuccess: Bool = false
        if let success, success >= 200 && success < 300 {
            isSuccess = true
        }
        return isSuccess
    }
    
}

struct UserInfoData: Codable {
    
    let id, firstName, lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName
    }
    
}
