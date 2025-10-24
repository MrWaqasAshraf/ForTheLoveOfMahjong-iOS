//
//  AppConstants.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 5/15/24.
//

import Foundation

enum DomainRoute: String{
    
    case api = "/api/"
    case nodeApi = "/nodeapi/"
    case images = "/images/"
    
}

class BaseUrlAndEndpointMaker {
    
    static func makeEndpoint(route: DomainRoute, endpoint: String) -> String {
        let formulatedBaseUrl = "\(route)\(route.rawValue)"
        return formulatedBaseUrl
    }
    
    static func makeBaseUrl(route: DomainRoute, inputBaseUrlDomain: String = baseUrlDomain) -> String {
        let formulatedBaseUrl = "\(inputBaseUrlDomain)\(route.rawValue)"
        return formulatedBaseUrl
    }
    
}

enum EndPoint: String {
    
    case loginApi = "/auth/login"
    case signUpApi = "/auth/signup"
    case dashboardApi = "/dashboard/events"
    case eventsListApi = "/events"
    // for favourite do this - > /events?favouritesOnly=true
    case createEventApi = "/events/add"
    case editEventApi = "/events/edit"
    // /events/edit/21    -> 12 is event id
    case forgotPasswordApi = "/auth/forgot-password"
    case resendOtpApi = "/auth/resend-otp"
    case verifyOtpApi = "/auth/verify-otp"
    case resetPasswordApi = "/auth/reset-password"
    case toggleFavouriteEventApi = "/events/favourite"
    // events/favourite/68c4701e906f31c863134ec3 -> 68c4701e906f31c863134ec3 is event id
    case eventDeleteRequestApi = "/events/request-delete"
    case eventDeleteApi = "/events/delete"
    // events/delete/68cbc75bd28a38e6d5972c5e -> 68cbc75bd28a38e6d5972c5e is event id
    case reportEventApi = "/event/report"
    case deleteUserApi = "/user/delete"
    
    //Test apis
    case dashboardTestApi = "/attendace_svc/pb/employee-detail/dashboard/"
    case businessEndpointApi = "/business_svc/pv/business/"
    
    case staffListApi = "/staff_svc/pv/staff/getStaffsByBussinessId"
    //?id=423&pageNo=1&pageSize=25
    case staffByUserAndBusinessId = "/staff_svc/pv/staff/getStaffsByUserAndBusinessId"
    //?userId=574&businessId=423
    
    case faqsListApi = "/faq"
    //?page=1&limit=20
    
  
}

enum SocketEventName: String {
    
    case message = "message"
    case updateUserLocation = "userLocation"
    case disconnect = "disconnect"
    case routeDeviation = "routeDeviation"
    case tripUpdated = "tripUpdated"
    case checkTripDeviation = "checkTripDeviation"
    
}

enum NotificationCenterNames {
    
    //Notifications for location manager
    //didFailWithError
    //didUpdateHeading
    //didUpdateLocations
    //didChangeAuthorization
    static let didUpdateLocations: Notification.Name = Notification.Name("didUpdateLocations")
    static let didUpdateHeading: Notification.Name = Notification.Name("didUpdateHeading")
    static let didChangeAuthorization: Notification.Name = Notification.Name("didChangeAuthorization")
    static let didFailWithError: Notification.Name = Notification.Name("didFailWithError")
    
}

extension Notification.Name {
    
    static let toggleFavourite: Notification.Name = Notification.Name("toggleFavourite")
    static let eventDetail: Notification.Name = Notification.Name("eventDetail")
    static let eventAdded: Notification.Name = Notification.Name("eventAdded")
    
    //Notifications for location manager
    //didFailWithError
    //didUpdateHeading
    //didUpdateLocations
    //didChangeAuthorization
    static let didUpdateLocations: Notification.Name = Notification.Name("didUpdateLocations")
    static let didUpdateHeading: Notification.Name = Notification.Name("didUpdateHeading")
    static let didChangeAuthorization: Notification.Name = Notification.Name("didChangeAuthorization")
    static let didFailWithError: Notification.Name = Notification.Name("didFailWithError")
    
}

enum CustomHeaderKeys: String {
    case a_id = "app-id"
}

enum HttpHeaderKey: String{
    case authorization = "Authorization"
    case language = "lang"
}

enum GMapKey: String{
    
    //For ios only
    case apiKey = "AIzaSyAE7XlUGTXjl7wwrm9lvUxoXCpgaPNPTDg"
    
}

enum TripStatus: String {
    
    case active = "active"
    case completed = "completed"
    case cancelled = "cancelled"
    
}

enum TransactionStatus: String {
    
    case succeeded = "succeeded"
    
}

enum SubscriptionSlug: String {
    case free = "free"
    case basicMonthly = "basic_monthly"
    case premiumMonthly = "premium_monthly"
    case premiumPlusMonthly = "premium_plus_monthly"
    case basicYearly = "basic_yearly"
    case premiumYearly = "premium_yearly"
    case premiumPlusYearly = "premium_plus_yearly"
}

enum AppLinks: String {
    case termsAndConditions = "https://fortheloveofmahjongg.com/terms-and-conditions"
}

enum AppFlow {
    case signUpsubscriptionFlow
    case addCardFlow
    case addCardWithSubscriptConfirmationFlow
    case generalSubscriptionUpdateFlow
}

enum AppLink {
    static let privacyPolicy = "https://fortheloveofmahjongg.com/privacy-policy"
    static let termsOfService = "https://fortheloveofmahjongg.com/terms-and-conditions"
}

enum AppRegex {
    
    static let visaCard = "^4[0-9]{12}(?:[0-9]{3})?$"
    static let masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
    static let americanExpressCard = "^3[47][0-9]{13}$"
    static let dinersClubCard = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
    static let discoverCard = "^6(?:011|5[0-9]{2})[0-9]{12}$"
    static let jcbCard = "^(?:2131|1800|35\\d{3})\\d{11}$"
    
}

enum PaymentMethodSlug: String {
    
    case visa = "visa"
    case masterCard = "mastercard"
    case americanExpress = "americanexpress"
    case diners = "diners"
    case discover = "discover"
    case jcb = "jcb"
    
}



enum SubscriptionDurationType: String {
    case yearly = "yearly"
    case monthly = "monthly"
}

enum ConfirmationMessage: String {
    
    case cardAddedSuccessfully = "Your card has been successfully authorized and added to your payment method."
    case subscribedSuccessfully = "You have successfully subscribed to ZeroIFTA."
    
}

enum RoleType: String {
    
    case trucker = "trucker"
    case company = "company"
    
}
