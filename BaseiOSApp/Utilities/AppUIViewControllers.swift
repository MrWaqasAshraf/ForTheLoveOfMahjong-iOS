//
//  AppUIViewControllers.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit
import SideMenu

class AppUIViewControllers {
    
    static func addEventScreen(viewModel: EventAndFilterViewModel = EventAndFilterViewModel()) -> AddEventScreen {
        let sb = UIStoryboard(name: AddEventScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: AddEventScreen.identifier) { coder in
            AddEventScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    static func filterEventsScreen(viewModel: EventAndFilterViewModel = EventAndFilterViewModel()) -> FilterEventsScreen {
        let sb = UIStoryboard(name: FilterEventsScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: FilterEventsScreen.identifier) { coder in
            FilterEventsScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    static func sideMenuScreen(viewModel: SideMenuViewModel = SideMenuViewModel()) -> SideMenuScreen {
        let sb = UIStoryboard(name: SideMenuScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: SideMenuScreen.identifier) { coder in
            SideMenuScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    static func mainMapScreen(viewModel: MainMapViewModel = MainMapViewModel()) -> MainMapScreen {
        let sb = UIStoryboard(name: MainMapScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: MainMapScreen.identifier) { coder in
            MainMapScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    static func setupSideMenu(vc: UIViewController) -> SideMenuNavigationController{
        let sideMenu = SideMenuNavigationController(rootViewController: vc)
        sideMenu.presentationStyle = .menuSlideIn
        sideMenu.presentationStyle.onTopShadowOpacity = 0.5
        return sideMenu
    }
    
    static func tasksCalendarScreen(viewModel: TasksCalendarViewModel = TasksCalendarViewModel()) -> TasksCalendarScreen {
        let sb = UIStoryboard(name: TasksCalendarScreen.identifier, bundle: nil)
        let vc = sb.instantiateViewController(identifier: TasksCalendarScreen.identifier) { coder in
            TasksCalendarScreen(coder: coder, viewModel: viewModel)
        }
        return vc
    }
    
    static func firstScreen(isFirstOpen: Bool = false) -> ViewController {
        let sb = UIStoryboard(name: ViewController.identifier, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ViewController.vcIdentifier) as! ViewController
        vc.isFirstOpen = isFirstOpen
        return vc
    }
    
//    static func setupPreLoginFirstScreen(showSignUp: Bool = false) -> UIViewController {
//        let vcOne = signInScreen(viewModel: SignInViewModel(showSignUp: showSignUp))
//        let navVc = UINavigationController(rootViewController: vcOne)
//        navVc.setNavigationBarHidden(true, animated: false)
//        navVc.viewControllers = [vcOne]
//        return navVc
//    }
    
//    static func setupPostLoginFirstScreen() -> UIViewController {
//        let vcOne = signInScreen()
////        let vcTwo = homeScreen()
//        let vcTwo = dashboardMapScreen()
//        let navVc = UINavigationController(rootViewController: vcOne)
//        navVc.setNavigationBarHidden(true, animated: false)
//        navVc.viewControllers = [vcOne, vcTwo]
//        return navVc
//    }
    
    static func topMostController(controller: UIViewController? =  UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topMostController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topMostController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topMostController(controller: presented)
        }
        return controller
    }
    
}

class NavigationHandler{
    
    static func navigateWithAnimation(controller: UIViewController, setTime: TimeInterval){
        DispatchQueue.main.asyncAfter(deadline: .now() + setTime, execute: {
            guard let window = UIApplication.shared.windows.first else{
                return
            }
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                window.makeKeyAndVisible()
            })
        })
    }
    
}
