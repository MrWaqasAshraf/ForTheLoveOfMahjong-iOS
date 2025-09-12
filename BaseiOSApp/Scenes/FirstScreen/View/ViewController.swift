//
//  ViewController.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit

class ViewController: UIViewController {
    
    static let identifier = "Main"
    static let vcIdentifier = "ViewController"
    
    @IBOutlet weak var logoIcon: UIImageView!
    
    var isFirstOpen: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("First screen")
        
        if isFirstOpen {
            
            appNavigationCoordinator.navigationController = navigationController
            
            logoIcon.animShow()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appNavigationCoordinator.shouldShowNavController(show: true, animted: false)
                let vc = AppUIViewControllers.mainMapScreen()
                appNavigationCoordinator.pushUIKit(vc)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationCoordinator.shouldShowNavController(show: false, animted: false)
    }

    @IBAction func nextBtn(_ sender: Any) {
        if isFirstOpen {
            let vc = AppUIViewControllers.mainMapScreen()
            appNavigationCoordinator.pushUIKit(vc)
        }
        else {
            //SampleSwiftUIScreen
//            let swiftUiVc = SampleSwiftUIScreen()
//            appNavigationCoordinator.pushSwiftUI(swiftUiVc)
            
//            let vc = AppUIViewControllers.tasksCalendarScreen()
//            appNavigationCoordinator.pushUIKit(vc)
            
        }
        
    }
    
}

