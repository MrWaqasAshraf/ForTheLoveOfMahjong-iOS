//
//  SideMenuViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import Foundation

struct SideMenuOptionModel {
    var title: String
    var showOptions: Bool = false
    var options: [SideMenuOptionData] = []
    var slug: SideMenuSlug
    var image: String
    var isOn: Bool = false
}

struct SideMenuOptionData {
    var image: String
    var title: String
    var isPremium: Bool = false
    var slug: SideMenuSlug
}

enum SideMenuSlug {
    
    case profile
    case events
    case favorite
    case contactUs
    case faqs
    case darkMode
    case logout
    case login
    
}

class SideMenuViewModel {
    
    var sideMenuOptionsList: [SideMenuOptionModel] = [.init(title: "Profile", slug: .profile, image: .groupProfileIconSystem),
                                                      .init(title: "Special events", slug: .events, image: .docIconSystem),
                                                      .init(title: "Favorite", slug: .favorite, image: .hearIconSystem),
                                                      .init(title: "Contacts us", slug: .contactUs, image: .contact_us_icon),
                                                      .init(title: "FAQs", slug: .faqs, image: .language_icon_svg),
//                                                      .init(title: "Dark Mode", slug: .darkMode, image: .moonHalfIconSystem, isOn: false)
    ]
    
    init() {
        checkLogoutStatus()
    }
    
    func checkLogoutStatus() {
        if let appUserData {
            if !sideMenuOptionsList.contains(where: { $0.slug == .logout }) {
                sideMenuOptionsList.append(.init(title: "Logout", slug: .logout, image: .logout_icon_system))
            }
            sideMenuOptionsList.removeAll { $0.slug == .login }
        }
        else {
            sideMenuOptionsList.removeAll { $0.slug == .logout }
            
            if !sideMenuOptionsList.contains(where: { $0.slug == .login }) {
                sideMenuOptionsList.append(.init(title: "Login", slug: .login, image: .login_icon_svg))
            }
            
        }
    }
    
}
