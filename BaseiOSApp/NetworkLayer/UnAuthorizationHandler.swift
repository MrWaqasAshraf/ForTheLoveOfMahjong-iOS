//
//  UnAuthorizationHandler.swift
//  rebox
//
//  Created by Waqas Ashraf on 13/03/2024.
//

import UIKit
//import SideMenu
//import GoogleSignIn
//import FBSDKLoginKit

enum StatusCode: Int{
    
    case unAuthorized = 403
    case sessionUnAuth = 401
    case appUpdate = 406
    
}

class UnAuthorizationHandler {
    
    static func isUnAuthorizationErrorCode(_ code : Int, isFirst: Bool? = nil ) ->  Bool {
        
//        return true
        if code == StatusCode.unAuthorized.rawValue || code == StatusCode.sessionUnAuth.rawValue || code == StatusCode.appUpdate.rawValue{
            
            DispatchQueue.main.async {
                ActivityIndicator.shared.removeActivityIndicator()
            }
            
            //Remove user data from local
            UserDefaultsHelper.removeUserAndToken()
            
            //Navigate to root vc i.e sign-in vc
            setRootController(statusCode: code, isFirst: isFirst, message: /*code == StatusCode.unAuthorized.rawValue ?*/ "Unauthorized" /*: "Login Session time out!"*/)
            
            return true
        } else {
            return false
        }

    }
    
    static func setRootController(statusCode: Int, isFirst: Bool? = nil, message: String) {
        
        print("Unauth message: \(message)")
        
        let topVc = AppUIViewControllers.topMostController()
        
        if let topVc, topVc is ViewController /*|| topVc is SignInScreen*/ {
            print("Do nothing")
            
            //For runtime application update
            if statusCode == 406 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.triggerAppUpdate(message: message)
                }
            }
            
        }
        else if let navVc = topVc?.navigationController {
            
//            navVc.popToViewController(ofClass: SignInScreen.self)
            
            //For runtime application update
            if statusCode == 406 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.triggerAppUpdate(message: message)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    GenericToast.showToast(message: message)
                }
            }
            
        }
        else {
//            let vc = AppUIViewControllers.setupPreLoginFirstScreen()
//            NavigationHandler.navigateWithAnimation(controller: vc, setTime: 0)

            //For runtime application update
            if statusCode == 406 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.triggerAppUpdate(message: message)
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    GenericToast.showToast(message: message)
                }
            }
            
        }
        

    
//        AppUIViewControllers
//        UserDefaultsHelper.removeUser()
//        FBSDKLoginKit.LoginManager().logOut()
//        GIDSignIn.sharedInstance().signOut()
        
    }
    
    static func triggerAppUpdate(message: String? = nil){
        let midView = ReusableLabelUI.fromNib()
        let mutableMessage: String = "The new version of ZeroIFTA application is available on the AppStore. Kindly update your ZeroIFTA application to continue availing our services".localizeString()
        let heading: String = /*message ??*/ "ZeroIFTA Update".localizeString()
        midView.titleLbl.text = mutableMessage
        AppDialogUI.addDialogView(headerTitle: heading, midViews: [midView], buttons: [.init("", style: .empty, height: 40), .init("Update".localizeString(), style: .appDefault, height: 40), .init("Close".localizeString(), style: .cancel, height: 40)]) { btnIndex, dialogUi in
            if btnIndex == 1 {
                // App Store URL.
                 
                 /* First create a URL, then check whether there is an installed app that can
                    open it on the device. */
                AppUrlHandler.openInputUrl(url: appStoreLink, type: .link)

            }
            DispatchQueue.main.async {
                dialogUi.removeFromSuperview()
            }
        }
    }
    
}

