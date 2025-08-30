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

var appSecurityManager: AppSecurityManager = AppSecurityManager()

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

var appRsaKey: String? {
    let rsaKey = KeychainManager.shared.retrieveKeyChainItem(key: CustomKeys.rsaKey, expectedItem: String.self)
    return rsaKey
}

var appUserCreds: UserCreds? {
    let userCreds = KeychainManager.shared.retrieveKeyChainItem(key: CustomKeys.userCredsKey, expectedItem: UserCreds.self)
    return userCreds
}
