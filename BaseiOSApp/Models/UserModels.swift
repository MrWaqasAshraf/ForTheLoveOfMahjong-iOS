//
//  UserModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

// MARK: - GeneralResponse
struct GeneralResponse: Codable {
    let success: Int?
    let message: String?
    
    var isSuccessful: Bool {
        var isSuccess: Bool = false
        if let success, success >= 200 && success < 300 {
            isSuccess = true
        }
        return isSuccess
    }
    
}

// MARK: - GeneralResponseTwo
struct GeneralResponseTwo: Codable {
    let success: Bool?
    let message: String?
}

// MARK: - UserResponse
struct UserResponse: Codable {
    
    let success: Int?
    let message: String?
    var data: UserData?
    
    var isSuccessful: Bool {
        var isSuccess: Bool = false
        if let success, success >= 200 && success < 300 {
            isSuccess = true
        }
        return isSuccess
    }
    
}

// MARK: - UserData
struct UserData: Codable {
    let userID, firstName, lastName, email: String?
    let role: String?
    var token: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case firstName, lastName, email, role, token
    }
}

// MARK: - StaffListResponse
struct StaffListResponse: Codable {
    var result: StaffListResult?
    let code: Int?
    let message: String?
}

// MARK: - StaffListResult
struct StaffListResult: Codable {
    var staff: [StaffData]?
}

// MARK: - StaffData
struct StaffData: Codable, Hashable {
    let id, staffID, centerAddressID, workingAddressID: Int?
    let businessID: Int?
    var title, firstName, lastName: String?
    let imageURL: String?
    let designation, qualification, nationality: String?
    let countryID: Int?
    let nationalTaxNumber: Int?
    let mobile, email, kinFirstName, kinLastName: String?
    let kinMobile: String?
    let kinEmail: String?
    let kinAddress: String?
    let hasServiceProvider: Bool?
    let projectID, userID: Int?
    let isPlexaarUser, isActive, isDeleted: Bool?
    let createdby: Int?
    let createdOn: String?
    let modifiedby: Int?
    let modifiedOn: String?
    let accountStatus: String?      //False, active, inactive
    let hasSchedule, hasAddress: Bool?
    let providerID, contractorID: Int?
    var isSelected: Bool?
    var fullName: String {
        var fullName: String = ""
        if let firstName, firstName != "" {
            fullName += firstName
        }
        if let lastName, lastName != "" {
            var connectingString: String = fullName.isEmpty ? "" : " "
            fullName += "\(connectingString)\(lastName)"
        }
        return fullName
    }

    enum CodingKeys: String, CodingKey {
        case id
        case staffID = "staffId"
        case centerAddressID = "centerAddressId"
        case workingAddressID = "workingAddressId"
        case businessID = "businessId"
        case title, firstName, lastName
        case imageURL = "imageUrl"
        case designation, qualification, nationality
        case countryID = "countryId"
        case nationalTaxNumber, mobile, email, kinFirstName, kinLastName, kinMobile, kinEmail, kinAddress, hasServiceProvider
        case projectID = "projectId"
        case userID = "userId"
        case isPlexaarUser, isActive, isDeleted, createdby, createdOn, modifiedby, modifiedOn, accountStatus, hasSchedule, hasAddress
        case providerID = "providerId"
        case contractorID = "contractorId"
    }
    
    init(id: Int? = nil, staffID: Int? = nil, centerAddressID: Int? = nil, workingAddressID: Int? = nil, businessID: Int? = nil, title: String? = nil, firstName: String? = nil, lastName: String? = nil, imageURL: String? = nil, designation: String? = nil, qualification: String? = nil, nationality: String? = nil, countryID: Int? = nil, nationalTaxNumber: Int? = nil, mobile: String? = nil, email: String? = nil, kinFirstName: String? = nil, kinLastName: String? = nil, kinMobile: String? = nil, kinEmail: String? = nil, kinAddress: String? = nil, hasServiceProvider: Bool? = nil, projectID: Int? = nil, userID: Int? = nil, isPlexaarUser: Bool? = nil, isActive: Bool? = nil, isDeleted: Bool? = nil, createdby: Int? = nil, createdOn: String? = nil, modifiedby: Int? = nil, modifiedOn: String? = nil, accountStatus: String? = nil, hasSchedule: Bool? = nil, hasAddress: Bool? = nil, providerID: Int? = nil, contractorID: Int? = nil) {
        self.id = id
        self.staffID = staffID
        self.centerAddressID = centerAddressID
        self.workingAddressID = workingAddressID
        self.businessID = businessID
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.imageURL = imageURL
        self.designation = designation
        self.qualification = qualification
        self.nationality = nationality
        self.countryID = countryID
        self.nationalTaxNumber = nationalTaxNumber
        self.mobile = mobile
        self.email = email
        self.kinFirstName = kinFirstName
        self.kinLastName = kinLastName
        self.kinMobile = kinMobile
        self.kinEmail = kinEmail
        self.kinAddress = kinAddress
        self.hasServiceProvider = hasServiceProvider
        self.projectID = projectID
        self.userID = userID
        self.isPlexaarUser = isPlexaarUser
        self.isActive = isActive
        self.isDeleted = isDeleted
        self.createdby = createdby
        self.createdOn = createdOn
        self.modifiedby = modifiedby
        self.modifiedOn = modifiedOn
        self.accountStatus = accountStatus
        self.hasSchedule = hasSchedule
        self.hasAddress = hasAddress
        self.providerID = providerID
        self.contractorID = contractorID
    }
    
}
