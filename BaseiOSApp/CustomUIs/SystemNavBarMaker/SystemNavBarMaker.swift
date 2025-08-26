//
//  SystemNavBarMaker.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 09/08/2025.
//

import UIKit

enum BarButtonPostion {
    case left
    case right
    case center
}

struct BarButtonItemModel {
    var barButton: UIBarButtonItem
}

struct NavBarSetttings {
    var title: String? = nil
    var titleView: UIView? = nil
    var hideSystemBackButton: Bool
    var buttonsSetup: [BarButtonModel]? = nil
}

struct BarButtonModel {
    var position: BarButtonPostion
    var barButtons: [UIBarButtonItem] = []
    var customView: UIView? = nil
}

extension UIViewController {
    
    func createSystemNavBar(systemNavBarSetup: NavBarSetttings) {
        for barBtn in systemNavBarSetup.buttonsSetup ?? [] {
            let barButtons: [UIBarButtonItem]? = barBtn.barButtons
            switch barBtn.position {
            case .left:
                if let barButtons {
                    navigationItem.leftBarButtonItems = barButtons
                }
            case .right:
                if let barButtons {
                    navigationItem.rightBarButtonItems = barButtons
                }
            case .center:
                if let customView = barBtn.customView {
                    navigationItem.titleView = customView
                }
            }
        }
        
        if let title = systemNavBarSetup.title {
            navigationItem.title = title
        }
        if let titleView = systemNavBarSetup.titleView {
            navigationItem.titleView = titleView
        }
        navigationItem.hidesBackButton = systemNavBarSetup.hideSystemBackButton
    }
    //  func backButtonImage(){
    //    let backButtonImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
    //    let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
    //    navigationItem.leftBarButtonItems = [backButton]
    //    navigationItem.hidesBackButton = true
    //  }
    //  @objc private func backButtonTapped() {
    //    navigationController?.popViewController(animated: true)
    //  }
    func initialSetupforHeader(color: UIColor = .clr_primary){
        //Add to navigation
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = color
        navigationController?.navigationBar.isTranslucent = false
        navAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        //navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem.init()
        //    let profile = getprofile()
        //    navigationItem.rightBarButtonItems = [profile]
        //    let menu = getmenu()
        //    navigationItem.leftBarButtonItems = [menu]
    }
}

