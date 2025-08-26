//
//  MainMapScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit
import SideMenu

class MainMapScreen: UIViewController {
    
    static let identifier = "MainMapScreen"
    
    private var sideMenuVc: SideMenuNavigationController?
    
    private var viewModel: MainMapViewModel
    
    init?(coder: NSCoder, viewModel: MainMapViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUiElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationCoordinator.shouldShowNavController(show: true, animted: false)
    }
    
    private func setupUiElements() {
        
        //Setup side menu
        let vc = AppUIViewControllers.sideMenuScreen()
//        vc.closure = { [weak self] in
//            DispatchQueue.main.async{
//                self?.displayLogoutAlert()
//            }
//        }
//        vc.languageClosure = { [weak self] in
//            DispatchQueue.main.async {
//                self?.displayLanguageUi()
//            }
//        }
//        vc.navigationClosure = { [weak self] nextVc in
//            if let nextVc {
//                DispatchQueue.main.async {
//                    self?.show(nextVc, sender: self)
//                }
//            }
//        }
        sideMenuVc = AppUIViewControllers.setupSideMenu(vc: vc)
        sideMenuVc?.setNavigationBarHidden(true, animated: true)
        //         sideMenuVc?.menuWidth = view.bounds.width - 50
        sideMenuVc?.menuWidth = 280
        SideMenuManager.default.leftMenuNavigationController = sideMenuVc
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
        //Setup nav bar
        let img: UIImage = .hamburgerIconSystem.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(showSideMenuScreen))
        barBtn.tintColor = .black
        let img2: UIImage = .defaultPersonImage.withRenderingMode(.alwaysTemplate)
        let barBtn2 = UIBarButtonItem(image: img2, style: .plain, target: self, action: #selector(filterEventsScreen))
        barBtn2.tintColor = .black
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .right, barButtons: [barBtn2])]))
        
    }
    
    private func shouldShowNavBar(show: Bool) {
        if show {
            if navigationController?.isNavigationBarHidden == true {
                appNavigationCoordinator.shouldShowNavController(show: show, animted: false)
            }
        }
        else {
            if navigationController?.isNavigationBarHidden == false {
                appNavigationCoordinator.shouldShowNavController(show: show, animted: false)
            }
        }
        
    }
    
    @objc
    private func filterEventsScreen(){
        let vc = AppUIViewControllers.filterEventsScreen()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc
    private func showSideMenuScreen(){
        guard let sideMenuVc else { return }
        present(sideMenuVc, animated: true)
    }
    
}

extension MainMapScreen {
    
    private func bindViewModel() {
        
    }
    
}
