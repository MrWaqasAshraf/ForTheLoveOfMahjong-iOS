//
//  UserDefaultsManager.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import Foundation

enum MapViewType: Codable {
    
    case defaultType
    case terrain
    case satellite
    
}

struct MapTypeModel: Codable {
    var mapType: MapViewType
    var isSelected: Bool = false
}

struct MapSettingModel: Codable {
    var mapStyle: MapTypeModel
    var enableTraffic: Bool
}

class UserDefaultsHelper{
    
    static let defaults = UserDefaults.standard
    
    private static let appName = "mahjong_app"
    
    private static let userRootKey = "\(appName)_user"
    private static let credsKey = "\(appName)_creds"
    private static let authTokenKey = "\(appName)_authToken"
    private static let selectedLanguageKey = "\(appName)_selectedLanguage"
    private static let firstStartKey = "\(appName)_firstStartSet"
    private static let appMapSettingsKey = "\(appName)_appMapSettings"
    
    //MARK: Save
    
    static var appMapSettings: MapSettingModel? {
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                defaults.setValue(data, forKey: appMapSettingsKey)
                defaults.synchronize()
            }
            catch {
                print("Unable to encode model")
            }
        }
        get {
            guard let data = defaults.value(forKey: appMapSettingsKey) as? Data else{
                return nil
            }
            do{
                let model = try JSONDecoder().decode(MapSettingModel.self, from: data)
                return model
            }
            catch{
                AppLogger.error("Error decoding/retreiving map setting data: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static var appSelectedLanguage: LangaugeModel? {
        
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                defaults.setValue(data, forKey: selectedLanguageKey)
                defaults.synchronize()
            }
            catch {
                print("Unable to encode model")
            }
        }
        get {
            guard let data = defaults.value(forKey: selectedLanguageKey) as? Data else{
                return nil
            }
            do{
                let model = try JSONDecoder().decode(LangaugeModel.self, from: data)
                return model
            }
            catch{
                AppLogger.error("Error decoding/retreiving map setting data: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static var appUserData: UserData? {
        set {
            do {
                
                var mutableNewValue: UserData? = newValue
                
                //Save token in keychain
                if let token = mutableNewValue?.token, token != ""{
                    KeychainManager.shared.saveInKeyChain(key: CustomKeys.appToken, inputData: mutableNewValue)
                }
                
                mutableNewValue?.token = nil
                
                let data = try JSONEncoder().encode(mutableNewValue)
                
                defaults.setValue(data, forKey: userRootKey)
                defaults.synchronize()
            }
            catch {
                print("Unable to encode model")
            }
        }
        get {
            guard let data = defaults.value(forKey: userRootKey) as? Data else{
                return nil
            }
            do{
                let model = try JSONDecoder().decode(UserData.self, from: data)
                return model
            }
            catch{
                AppLogger.error("Error decoding/retreiving map setting data: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
//    static func getAppMapSettings() -> MapSettingModel? {
//        guard let data = UserDefaults.standard.value(forKey: appMapSettingsKey) as? Data else{
//            return nil
//        }
//        do{
//            let model = try JSONDecoder().decode(MapSettingModel.self, from: data)
//            return model
//        }
//        catch{
//            AppLogger.error("Error decoding/retreiving map setting data: \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    static func saveMapSettings(mapSetting: MapSettingModel) {
//        do {
//            let data = try JSONEncoder().encode(mapSetting)
//            UserDefaults.standard.setValue(data, forKey: appMapSettingsKey)
//        }
//        catch {
//            print("Unable to encode model")
//        }
//    }
    
//    static func setFirstStart() {
//        UserDefaults.standard.set("FirstStartSet", forKey: firstStart)
//    }
//    
//    static func getFirstStart() -> String? {
//        return UserDefaults.standard.value(forKey: firstStart) as? String
//    }
    
    //UserData
//    static func saveUserDataAndToken(userData: UserData?){
//        if var userData = userData{
//            do {
//                
//                //Save token in keychain
//                if let token = userData.token, token != ""{
//                    KeychainManager.shared.saveInKeyChain(key: CustomKeys.appToken, inputData: token)
//                }
//                
//                if let rsaKey = userData.rsaKey, rsaKey != "" {
//                    KeychainManager.shared.saveInKeyChain(key: CustomKeys.rsaKey, inputData: rsaKey)
//                }
//                
//                userData.token = nil
//                let data = try JSONEncoder().encode(userData)
//                UserDefaults.standard.setValue(data, forKey: userRootKey)
//                
//            } catch {
//                AppLogger.error("Error encoding user data to user defaults: \(error.localizedDescription)")
//            }
//        }
//        else{
//            AppLogger.error("User is empty")
//        }
//    }
    
    static func setLanguageToAppleLanguages(languageSymbol: String?) {
        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        UserDefaults.standard.set([languageSymbol ?? "en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    //Selected language
    static func saveSelectedLanguage(languageData: LangaugeModel?){
        if let languageData = languageData{
            do {
                
                let data = try JSONEncoder().encode(languageData)
                UserDefaults.standard.setValue(data, forKey: selectedLanguageKey)
                
                setLanguageToAppleLanguages(languageSymbol: languageData.languageSymbol)
//                UserDefaults.standard.set([languageData.languageSymbol], forKey: "AppleLanguages")
//                UserDefaults.standard.synchronize()
                
                
            } catch {
                AppLogger.error("Error encoding selected language data to user defaults: \(error.localizedDescription)")
            }
        }
        else{
            AppLogger.error("selected language is empty")
        }
    }
    
    //MARK: Remove
    //UserData
    static func removeUserAndToken(){
        UserDefaults.standard.setValue(nil, forKey: userRootKey)
        UserDefaults.standard.removeObject(forKey: userRootKey)
        UserDefaults.standard.setValue(nil, forKey: authTokenKey)
        UserDefaults.standard.removeObject(forKey: authTokenKey)
        KeychainManager.shared.deleteFromKeychain(key: CustomKeys.appToken)
        KeychainManager.shared.deleteFromKeychain(key: CustomKeys.rsaKey)
    }
    
    static func removeSelectedLanguage(){
        UserDefaults.standard.setValue(nil, forKey: selectedLanguageKey)
        UserDefaults.standard.removeObject(forKey: selectedLanguageKey)
    }
    
    //MARK: Get
    //UserData
//    static func getUserData() -> UserData?{
//        guard let data = UserDefaults.standard.value(forKey: userRootKey) as? Data else{
//            return nil
//        }
//        do{
//            let user = try JSONDecoder().decode(UserData.self, from: data)
////            AppLogger.info("User data fetched successfully: \(user)")
//            return user
//        }
//        catch{
////            AppLogger.error("Error decoding/retreiving user data: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    //Selected language
    static func getSelectedLanguage() -> LangaugeModel?{
        guard let data = UserDefaults.standard.value(forKey: selectedLanguageKey) as? Data else{
            return nil
        }
        do{
            let selectedLanguage = try JSONDecoder().decode(LangaugeModel.self, from: data)
            AppLogger.info("User data fetched successfully: \(selectedLanguage)")
            return selectedLanguage
        }
        catch{
            AppLogger.error("Error decoding/retreiving user data: \(error.localizedDescription)")
            return nil
        }
    }
    
    //Token
//    static func getCurrentToken() -> String?{
//        guard let data = UserDefaults.standard.value(forKey: authToken) as? Data else{
//            return nil
//        }
//        do{
//            let token = try JSONDecoder().decode(String.self, from: data)
//            AppLogger.info("Token data fetched successfully: \(token)")
//            return token
//        }
//        catch{
//            AppLogger.error("Error decoding/retreiving token data: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
}
