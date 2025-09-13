//
//  LocationPermissionsManager.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 13/09/2025.
//

import UIKit

var locationPermissionsManager: LocationPermissionsManager = LocationPermissionsManager.shared

class LocationPermissionsManager {
    
    private init() {}
    
    static let shared: LocationPermissionsManager = LocationPermissionsManager()
    
    @discardableResult
    func checkLocationSetting() -> Bool {
        
        //        let currentLocationStatus = CLLocationManager.locationServicesEnabled()
        
        var currentLocationValid = false
        let locationStatus = appLocationManager.authorizationStatus
        
//        if let userData = appUserData {
            switch locationStatus {
            case .notDetermined:
                print("It is notDetermined")
//                turnOnLocationOrgoOffline()
                currentLocationValid = false
                appLocationManager.requestAlwaysAuthorization()
            case .restricted:
                print("It is restricted")
                currentLocationValid = false
                turnOnLocationOrgoOffline()
            case .denied:
                print("It is denied")
                currentLocationValid = false
                turnOnLocationOrgoOffline()
            case .authorizedAlways:
                print("It is authorizedAlways")
                print("Do nothing")
                currentLocationValid = true
                removeLocationAlertIfRequired()
            case .authorizedWhenInUse:
                print("It is authorizedWhenInUse")
                currentLocationValid = false
                turnOnLocationOrgoOffline(turnToAlways: true)
                appLocationManager.requestAlwaysAuthorization()
            case .authorized:
                print("It is authorized")
                currentLocationValid = false
                turnOnLocationOrgoOffline(turnToAlways: true)
                appLocationManager.requestAlwaysAuthorization()
            @unknown default:
                currentLocationValid = false
                print("Do nothing")
            }
//        }
//        else{
//
//        }
        return currentLocationValid
    }
    
    private func removeLocationAlertIfRequired() {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
        for subView in keyWindow?.subviews ?? [] {
            if subView.tag == 11011 {
                DispatchQueue.main.async {
                    subView.removeFromSuperview()
                }
                break
            }
        }
    }
    
    private func turnOnLocationOrgoOffline(turnToAlways: Bool = false){
        print("Turn on location is called")
        let summaryText: String = turnToAlways ? "Please turn on your device location or Logout".localizeString(originalText: "Please turn on your device location or Logout") : "Location turned off, Please turn on your device location or logout".localizeString(originalText: "Location turned off, Please turn on your device location or logout")
        let headerTitle: String = turnToAlways ? "Location permission".localizeString(originalText: "Location permission") : "Location Turned Off".localizeString(originalText: "Location Turned Off")
        let titleView = ReusableLabelUI.fromNib()
        titleView.titleLbl.text = summaryText
        AppDialogUI.addDialogView(tag: 11011, headerTitle: headerTitle, midViews: [titleView], buttons: [.init("", style: .empty, height: 40), .init("Go to Settings".localizeString(originalText: "Go to Settings"), style: .appDefault, height: 40), .init("Logout".localizeString(originalText: "Logout"), style: .cancel, height: 40)]) { [weak self] btnIndex, dialogUi in
            
            if btnIndex == 1 {
                
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                
                DispatchQueue.main.async {
                    dialogUi.removeFromSuperview()
                }
                
            }
            else if btnIndex == 2 {
//                self?.logoutApi(view: dialogUi)
                self?.clearSessionAndLogout()
                
//                DispatchQueue.main.async {
//                    self?.clearSessionAndLogout()
//                    dialogUi.removeFromSuperview()
//                }
            }
            
            
        }
    }
    
//    private func logoutApi(view: UIView) {
//        
//        DispatchQueue.main.async {
//            ActivityIndicator.shared.showActivityIndicator(view: view)
//        }
//        
//        appSessionManager.logoutApi { [weak self] result in
//            ActivityIndicator.shared.removeActivityIndicator()
//            switch result{
//            case .success((let data, _)):
//                DispatchQueue.main.async {
//                    view.removeFromSuperview()
//                    self?.clearSessionAndLogout()
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                DispatchQueue.main.async {
//                    view.removeFromSuperview()
//                    self?.clearSessionAndLogout()
//                }
//            }
//        }
//    }
    
    private func clearSessionAndLogout() {
        UserDefaultsHelper.removeUserAndToken()
//        let topVc = AppUIViewControllers.topMostController()
//        if let navVc = topVc?.navigationController {
//            navVc.popToViewController(ofClass: SignInScreen.self)
//        }
//        else {
//            let vc = AppUIViewControllers.setupPreLoginFirstScreen()
//            NavigationHandler.navigateWithAnimation(controller: vc, setTime: 0)
//        }
    }
    
}

