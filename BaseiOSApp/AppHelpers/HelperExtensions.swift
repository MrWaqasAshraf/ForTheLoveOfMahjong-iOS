//
//  HelperExtensions.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit

extension UINavigationController {
    
    @discardableResult
    func popToViewController(ofClass: AnyClass, animated: Bool = true) -> Bool {
        var vcFound: Bool = false
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            vcFound = true
            popToViewController(vc, animated: animated)
        }
        else {
            vcFound = false
        }
        return vcFound
    }
    
}

extension Date {
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func getMonth(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func addDaysToDate(days: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: self)
    }
    
    func addWeekToDate(weeks: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: weeks, to: self)
    }
    
    func addMonthsToDate(months: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: months, to: self)
    }
    
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
}

extension Date {
  func addDays(_ days: Int) -> Date {
    Calendar.autoupdatingCurrent.date(byAdding: .day, value: days, to: self)!
  }
}

extension Double {
    func truncate(places : Int = 3)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIStackView{
    
    func removeAllSubviews(){
        for view in self.arrangedSubviews{
            view.removeFromSuperview()
        }
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func removeSpecificView(subViewType: AnyClass){
        for view in self.arrangedSubviews{
            if view.isKind(of: subViewType) {
                view.removeFromSuperview()
            }
        }
    }
    
}

public protocol NibInstantiatable {
    
    static func nibName() -> String
    
}

extension NibInstantiatable {
    
    static func nibName() -> String {
        return String(describing: self)
    }
    
}

extension NibInstantiatable where Self: UIView {
    
    static func fromNib() -> Self {
        
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        
        return nib!.first as! Self
        
    }
    
}

//import SDWebImage
//extension UIImageView{
//    
////    func getUrlImage(inputRoute: String? = nil, url: String?){
////        let mutableBaseUrl = "\(baseUrlDomain)\(inputRoute ?? DomainRoute.images.rawValue)"
////        guard let url else { return }
////        let imageUrlString: String = "\(mutableBaseUrl)\(url)"
////        print("Image url: \(imageUrlString)")
////        let imageUrl: URL? = URL(string: imageUrlString)
////        self.sd_setImage(with: imageUrl)
////    }
////
//    func getFullUrlImage(url: String?, placeHolderImage: UIImage? = .placeholder_image){
//        guard let url else { return }
//        let imageUrl: URL? = URL(string: url)
//        self.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage)
//    }
//    
//}

extension Float {
    
    func cleanUpto(trailingDigitsCount: Int) -> String {
        return String(format: "%.\(trailingDigitsCount)f", self)
    }
    
}

extension Double {
    
    func cleanUpto(trailingDigitsCount: Int) -> String {
        return String(format: "%.\(trailingDigitsCount)f", self)
    }
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    var clean: String {
       return String(format: "%.0f", self)
    }
    
//    var cleanValue: String {
//        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
//    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension String? {
    
    func convertToNumberFormat() -> String? {
        guard let inputViewText = self else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        if inputViewText.count >= 1 {
            guard let number = Double(inputViewText.replacingOccurrences(of: ",", with: "")),
                  let result = formatter.string(from: NSNumber(value: number)) else { return self }
            return result
        }
        return self
    }
    
}

extension String {
    
    func separated(by separator: String = " ", stride: Int = 4) -> String {
        return enumerated().map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }.joined()
    }
    
    func validateEmail() -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)

    }
    
    func getCardAsset(tintColor: UIColor? = nil, renderMode: UIImage.RenderingMode? = nil) -> UIImage {
        let cardType = PaymentMethodSlug(rawValue: self.replacingOccurrences(of: " ", with: "").lowercased())
        switch cardType {
        case .visa:
            let card: UIImage = .visa_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        case .masterCard:
            let card: UIImage = .mastercard_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        case .americanExpress:
            let card: UIImage = .american_express_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        case .diners:
            let card: UIImage = .diners_club_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        case .discover:
            return .discover_card_icon
        case .jcb:
            return .jcb_card_icon
        case nil:
            let card: UIImage = .defauldCardIconFillSystem
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
    }
    
    func validateCard(tintColor: UIColor? = nil, renderMode: UIImage.RenderingMode? = nil) -> UIImage {

        let visa = NSPredicate(format:"SELF MATCHES %@", AppRegex.visaCard)
        let master = NSPredicate(format:"SELF MATCHES %@", AppRegex.masterCard)
        let american = NSPredicate(format:"SELF MATCHES %@", AppRegex.americanExpressCard)
        let diners = NSPredicate(format:"SELF MATCHES %@", AppRegex.dinersClubCard)
        let discover = NSPredicate(format:"SELF MATCHES %@", AppRegex.discoverCard)
        let jcb = NSPredicate(format:"SELF MATCHES %@", AppRegex.jcbCard)
        
        let isVisa = visa.evaluate(with: self)
        let isMaster = master.evaluate(with: self)
        let isAmerica = american.evaluate(with: self)
        let isDiners = diners.evaluate(with: self)
        let isDiscover = discover.evaluate(with: self)
        let isJcb = jcb.evaluate(with: self)
        
        if isVisa {
            let card: UIImage = .visa_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
        else if isMaster {
            let card: UIImage = .mastercard_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
        else if isAmerica {
            let card: UIImage = .american_express_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
        else if isDiners {
            let card: UIImage = .diners_club_card_icon
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
        else if isDiscover {
            return .discover_card_icon
        }
        else if isJcb {
            return .jcb_card_icon
        }
        else {
            let card: UIImage = .defauldCardIconFillSystem
            if let tintColor {
                card.withRenderingMode(.alwaysTemplate).withTintColor(tintColor)
            }
            return card
        }
        

    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
}

extension UIViewController {
    
    func animateView(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
        })
    }
    
}

import CoreLocation

extension CLLocation {
    convenience init?(_ coordinate2D: CLLocationCoordinate2D) {
        guard CLLocationCoordinate2DIsValid(coordinate2D) else { return nil }
        self.init(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
    }
}
