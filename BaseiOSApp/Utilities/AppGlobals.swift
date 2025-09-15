//
//  AppGlobals.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import Foundation

var appFcmToken: String?

struct UserCreds: Codable {
    var email: String?
    var password: String?
}


var profileFetched: Bindable<Bool> = Bindable(false)

var appSecurityManager: AppSecurityManager = AppSecurityManager()
var locationService: AppLocationService = AppLocationService()
var a_id: String {
    return MahjongFileManager.shared.accessPlistValues(plistName: .internalName, keyname: CustomHeaderKeys.a_id.rawValue, returnValuetype: String.self) ?? ""
}

var appUserData: UserData? {
    set {
        UserDefaultsHelper.appUserData = newValue
    }
    get {
        let appUser = UserDefaultsHelper.appUserData
        return appUser
    }
}

var appMapSettings: MapSettingModel {
    if let appMapSetting = UserDefaultsHelper.appMapSettings {
        return appMapSetting
    }
    else {
        let defaultSetting = MapSettingModel(mapStyle: .init(mapType: .defaultType, isSelected: true), enableTraffic: false)
        return defaultSetting
    }
    
}

var appSelectedLanguage: LangaugeModel? {
    let selectedLanguage = UserDefaultsHelper.appSelectedLanguage
    return selectedLanguage
}

var appAuthToken: String? {
    let authToken = KeychainManager.shared.retrieveKeyChainItem(key: CustomKeys.appToken, expectedItem: String.self)
    return authToken
}

var appUserCreds: UserCreds? {
    let userCreds = KeychainManager.shared.retrieveKeyChainItem(key: CustomKeys.userCredsKey, expectedItem: UserCreds.self)
    return userCreds
}
