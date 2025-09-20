//
//  NavigationCoordinator.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 07/08/2025.
//

import UIKit
import SwiftUI

var appNavigationCoordinator: NavigationCoordinator = NavigationCoordinator()

class NavigationCoordinator {
    weak var navigationController: UINavigationController?
    
    func shouldShowNavController(show: Bool, animted: Bool) {
        navigationController?.setNavigationBarHidden(!show, animated: animted)
    }

    func pushSwiftUI<V: View>(_ view: V, animated: Bool = true) {
        let vc = UIHostingController(rootView: view)
        navigationController?.pushViewController(vc, animated: animated)
    }

    func pushUIKit(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    @discardableResult
    func popToSpecificVc(vc: AnyClass, animated: Bool = true) -> Bool? {
        return navigationController?.popToViewController(ofClass: vc, animated: animated)
    }
    
}
