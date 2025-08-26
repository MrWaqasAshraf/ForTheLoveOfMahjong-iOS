//
//  BusinessModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

enum BooleanCustomEnum: String {
    case isTrue = "True"
    case isFalse = "False"
}

// MARK: - BusinessListResponse
struct BusinessListResponse: Codable {
    let error: Bool?
    var result: [BusinessData]?
    let message: String?
    let statusCode: Int?
}

// MARK: - BusinessData
struct BusinessData: Codable {
    let user: String?
    let id: Int?
    let name, imageURL: String?
    let buisnessSchedules: [BuisnessScheduleModel]?
    var value: String?

    enum CodingKeys: String, CodingKey {
        case user, id, name, buisnessSchedules
        case imageURL = "imageUrl"
    }
}

// MARK: - BuisnessScheduleModel
struct BuisnessScheduleModel: Codable {
    let id: Int?
    let businessStartTime, businessEndTime, day: String?
    let isAvailable: Bool?
    let timezone: String?
    let businessID: Int?

    enum CodingKeys: String, CodingKey {
        case id, businessStartTime, businessEndTime, day, isAvailable, timezone
        case businessID = "businessId"
    }
}
