//
//  AttendanceModels.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import Foundation

// MARK: - DashboardResponse
struct DashboardResponse: Codable, Equatable {
    let error: Bool?
    var result: DashboardResult?
    let message: String?
    let code: Int?
}

// MARK: - DashboardResult
struct DashboardResult: Codable, Equatable {
    
    var attendanceDetails: [AttendanceStatusResult]?
    
    enum CodingKeys: String, CodingKey {
        case attendanceDetails = "attendanceDetails"
    }
    
}

enum BreakEventType: Codable {
    case staffBreak
    case clockIn
    case clockOut
}

// MARK: - BreaksData
struct BreaksData: Codable, Hashable {
    var type: BreakEventType?
    let breakIn, breakOut: BreakInfoModel?
}

// MARK: - BreakInfoModel
struct BreakInfoModel: Codable, Hashable {
    let date, time: String?
}

// MARK: - AttendanceStatusResult
struct AttendanceStatusResult: Codable, Hashable {
    
//    static func == (lhs: AttendanceStatusResult, rhs: AttendanceStatusResult) -> Bool {
//        return true
//    }
    
    let id, businessID, userID, employeeID, checkInId, checkOutId: Int?
    let markedByID, methodID: Int?
    let markedByType, firstCheckinTime, lastCheckoutTime, firstCheckinDate, checkinTime, checkoutTime, checkinDate, checkoutDate, lastCheckinTime, lastCheckinDate: String?
    let firstCheckinTimezone, lastCheckoutTimezone, lastCheckinTimezone, checkinTimezone, checkoutTimezone: String?
    let lastCheckoutDate: String?
    let totalHoursMS: Int?
    let workStatus, breakStatus: String?
    let staff: StaffData?
    var breakHistory: [BreaksData]?
    let employeeFirstname, employeeLastname, employeeEmail: String?
    var employeeFullName: String {
        var fullName: String = ""
        if let employeeFirstname {
            fullName += employeeFirstname
        }
        if let employeeLastname {
            let connectingString: String = fullName.isEmpty ? "" : " "
            fullName += "\(connectingString)\(employeeLastname)"
        }
        return fullName
    }
    
    var staffProductiveTime: String?
    var totalBreaksTime: String?
    
    var calculatedLastCheckInFullDateTime: Date? {
        let timeToConvert = "\(lastCheckinDate ?? "")T\(lastCheckinTime ?? "").000Z"
        var timeZone = TimeZone.current
        let converted = timeToConvert.convertToDateFormat(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", timeZone: lastCheckinTimezone == timeZone.identifier ? nil : timeZone)
        return converted
//        DateManager.convertStringToDate(inputDate: "\(checkinDate ?? "")T\(checkinTime ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
    }
    
    enum CodingKeys: String, CodingKey {
        
        //Old
//        case id
//        case businessID = "business_id"
//        case userID = "user_id"
//        case employeeID = "employee_id"
//        case markedByID = "marked_by_id"
//        case methodID = "method_id"
//        case markedByType = "marked_by_type"
//        case firstCheckinTime = "first_checkin_time"
//        case lastCheckoutTime = "last_checkout_time"
//        case firstCheckinDate = "first_checkin_date"
//        case lastCheckoutDate = "last_checkout_date"
//        case totalHoursMS = "total_hours_ms"
//        case workStatus = "work_status"
//        case breakStatus = "break_status"
//        case checkinTime = "checkin_time"
//        case checkoutTime = "checkout_time"
//        case checkinDate = "checkin_date"
//        case checkoutDate = "checkout_date"
//        case employeeFirstname = "employee_firstname"
//        case employeeLastname = "employee_lastname"
//        case employeeEmail = "employee_email"
        
        //New
        case id
        case staff, breakHistory, lastCheckinTime, lastCheckinDate
        case firstCheckinTimezone, lastCheckoutTimezone, lastCheckinTimezone, checkinTimezone, checkoutTimezone
        case checkInId = "checkinId"
        case checkOutId = "checkoutId"
        case businessID = "businessId"
        case userID = "userId"
        case employeeID = "staffId"
        case markedByID = "markedById"
        case methodID = "methodId"
        case markedByType = "markedByType"
        case firstCheckinTime = "firstCheckinTime"
        case lastCheckoutTime = "lastCheckoutTime"
        case firstCheckinDate = "firstCheckinDate"
        case lastCheckoutDate = "lastCheckoutDate"
        case totalHoursMS = "workingTotalHoursMs"
        case workStatus = "workStatus"
        case breakStatus = "breakStatus"
        case checkinTime = "checkinTime"
        case checkoutTime = "checkoutTime"
        case checkinDate = "checkinDate"
        case checkoutDate = "checkoutDate"
        case employeeFirstname = "firstName"
        case employeeLastname = "lastName"
        case employeeEmail = "email"
        
    }
    
    mutating func setProductiveTime() {
        
        let checkInFullDateTime = DateManager.convertStringToDate(inputDate: "\(checkinDate ?? "")T\(checkinTime ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
        let checkOutFullDateTime = DateManager.convertStringToDate(inputDate: "\(checkoutDate ?? "")T\(checkoutTime ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
        
        let checkInMili = checkInFullDateTime?.millisecondsSince1970 ?? 0
        let checkOutMili = checkOutFullDateTime?.millisecondsSince1970 ?? 0
        let productiveTime = checkOutMili - checkInMili
        let seconds = productiveTime/1000
        let mins = seconds/60
        let hrs = mins/60
        let remainingMins = mins%60
        
        let connectingMinPlural = remainingMins > 1 ? "s" : ""
        let connectingHrPlural = hrs > 1 ? "s" : ""
        let connectingHrs = hrs > 0 ? "\(hrs) Hr\(connectingHrPlural)" : ""
        let connectingMins = remainingMins > 0 ? "\(remainingMins) Min\(connectingMinPlural) ~" : ""
        let mid = (connectingHrs != "" && connectingMins != "") ? ", " : ""
        let calculatedProductiveTime = "\(connectingHrs)\(mid)\(connectingMins)"
        staffProductiveTime = calculatedProductiveTime != "" ? calculatedProductiveTime : "N/A"
        
    }
    
    mutating func setTotalBreakTimeTime() {
        
        let checkInFullDateTime = DateManager.convertStringToDate(inputDate: "\(checkinDate ?? "")T\(checkinTime ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
        let checkOutFullDateTime = DateManager.convertStringToDate(inputDate: "\(checkoutDate ?? "")T\(checkoutTime ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
        
        var totalMilliSeconds: Int64 = 0
        
        for workBreak in breakHistory ?? [] {
            if let breakOut = workBreak.breakOut?.date {
                let checkInFullDateTime = DateManager.convertStringToDate(inputDate: "\(workBreak.breakIn?.date ?? "")T\(workBreak.breakIn?.time ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
                let checkOutFullDateTime = DateManager.convertStringToDate(inputDate: "\(workBreak.breakOut?.date ?? "")T\(workBreak.breakOut?.time ?? "").000Z", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"/*, locale: "en_US_POSIX"*/)
                let checkInMili = checkInFullDateTime?.millisecondsSince1970 ?? 0
                let checkOutMili = checkOutFullDateTime?.millisecondsSince1970 ?? 0
                let productiveTime = checkOutMili - checkInMili
                totalMilliSeconds += productiveTime/1000
            }
            else {
                continue
            }
            
        }
        
//        let checkInMili = checkInFullDateTime?.millisecondsSince1970 ?? 0
//        let checkOutMili = checkOutFullDateTime?.millisecondsSince1970 ?? 0
//        let productiveTime = checkOutMili - checkInMili
//        let seconds = productiveTime/1000
//        let mins = seconds/60
//        let hrs = mins/60
//        let remainingMins = mins%60
        
        let mins = totalMilliSeconds/60
        let hrs = mins/60
        let remainingMins = mins%60
        
        let connectingMinPlural = remainingMins > 1 ? "s" : ""
        let connectingHrPlural = hrs > 1 ? "s" : ""
        let connectingHrs = hrs > 0 ? "\(hrs) Hr\(connectingHrPlural)" : ""
        let connectingMins = remainingMins > 0 ? "\(remainingMins) Min\(connectingMinPlural) ~" : ""
        let mid = (connectingHrs != "" && connectingMins != "") ? ", " : ""
        
        let calculatedProductiveTime = "\(connectingHrs)\(mid)\(connectingMins)"
        
        totalBreaksTime = calculatedProductiveTime != "" ? calculatedProductiveTime : "N/A"
        
    }
    
}
