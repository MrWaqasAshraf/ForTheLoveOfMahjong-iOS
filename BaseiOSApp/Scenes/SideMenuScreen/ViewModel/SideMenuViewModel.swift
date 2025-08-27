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
    case darkMode
    
}

class SideMenuViewModel {
    
    var sideMenuOptionsList: [SideMenuOptionModel] = [.init(title: "Profile", slug: .profile, image: .groupProfileIconSystem),
                                                      .init(title: "Events", slug: .events, image: .docIconSystem),
                                                      .init(title: "Favorite", slug: .favorite, image: .hearIconSystem),
                                                      .init(title: "Dark Mode", slug: .darkMode, image: .moonHalfIconSystem, isOn: false)]
    
}
