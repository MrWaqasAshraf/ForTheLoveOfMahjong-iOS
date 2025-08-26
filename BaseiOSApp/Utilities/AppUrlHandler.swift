//
//  AppUrlHandler.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit

let appStoreLink = "https://itunes.apple.com/us/app/apple-store/id375380948?mt=8"

enum AppUrlType {
    case phone(String = "tel://")
    case link
    case email(String = "mailto:")
    case googleMap(LocationLinkDataModel)
}

struct LocationLinkDataModel {
    var latitude: String
    var longitude: String
    var googleMapAppLink: String {
        return "?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)"
    }
    var googleMapLink: String {
        return "http://maps.google.com/maps?q=loc:\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)"
    }
}

class AppUrlHandler {
    
    static func openInputUrl(url: String? = nil, type: AppUrlType = .link) {
        switch type {
        case .phone(let string):
            openLink(urlString: "\(string)\(url ?? "")")
        case .link:
            openLink(urlString: url ?? "")
        case .email(let string):
            openLink(urlString: "\(string)\(url ?? "")")
        case .googleMap(let coordinates):
            let canOpen = openLink(urlString: coordinates.googleMapAppLink)
            if !canOpen {
                openLink(urlString: coordinates.googleMapLink)
            }
        }
    }
    
}

@discardableResult
func openLink(urlString: String) -> Bool {
    guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
        GenericToast.showToast(message: "Some issue occurred with the link")
        return false
    }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    } else {
        UIApplication.shared.openURL(url)
        return true
    }
}
