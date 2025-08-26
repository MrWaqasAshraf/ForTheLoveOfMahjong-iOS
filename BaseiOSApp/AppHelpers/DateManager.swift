//
//  DateManager.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 6/16/24.
//

import Foundation

class DateManager{
    
    private static var dateFormatter: DateFormatter = DateFormatter()
    
    class func convertDateToString(inputDate: Date?, dateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil, shouldShowDebugger: Bool = true) -> String{
        dateFormatter.dateFormat = dateFormat
        guard let inputDate else{
            return ""
        }
        if let locale{
            dateFormatter.locale = Locale(identifier: locale)
        }
        if let timeZone {
            dateFormatter.timeZone = timeZone
        }
        let stringDate = dateFormatter.string(from: inputDate)
        if shouldShowDebugger {
            print("Converted date to string: \(stringDate)")
        }
        return stringDate
    }
    
    class func convertStringToDate(inputDate: String, dateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil) -> Date?{
        dateFormatter.dateFormat = dateFormat
        if let locale{
            dateFormatter.locale = Locale(identifier: locale)
        }
        if let timeZone {
            dateFormatter.timeZone = timeZone
        }
        let date = dateFormatter.date(from: inputDate)
        return date
    }
    
    class func convertStringToStringDate(inputDate: String, dateFormat: String = "yyyy-MM-dd", outputDateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil) -> String{
        let date = convertStringToDate(inputDate: inputDate, dateFormat: dateFormat, locale: locale, timeZone: timeZone)
        let stringDate = convertDateToString(inputDate: date, dateFormat: outputDateFormat)
        return stringDate
    }
    
}

extension String {
    
    func convertToDateFormat(dateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil) -> Date? {
        let convertedDate = DateManager.convertStringToDate(inputDate: self, dateFormat: dateFormat, locale: locale, timeZone: timeZone)
        return convertedDate
    }
    
    func convertToOtherStringDate(dateFormat: String = "yyyy-MM-dd", outputDateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil) -> String {
        let convertedDate = DateManager.convertStringToStringDate(inputDate: self, dateFormat: dateFormat, outputDateFormat: outputDateFormat, locale: locale, timeZone: timeZone)
        return convertedDate
    }
    
}

extension Date {
    
    func convertToDateString(dateFormat: String = "yyyy-MM-dd", locale: String? = nil, timeZone: TimeZone? = nil, shouldShowDebugger: Bool = true) -> String {
        let convertedDate = DateManager.convertDateToString(inputDate: self, dateFormat: dateFormat, locale: locale, timeZone: timeZone, shouldShowDebugger: shouldShowDebugger)
        return convertedDate
    }
    
}
