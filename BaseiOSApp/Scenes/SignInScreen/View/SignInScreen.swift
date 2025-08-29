//
//  SignInScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/08/2025.
//

import UIKit

class SignInScreen: UIViewController {
    
    static let identifier = "SignInScreen"
    
    private var viewModel: SignInViewModel
    
    init?(coder: NSCoder, viewModel: SignInViewModel) {
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
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn])]))
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    //MARK: ButtonAction
    @IBAction func signUpBtn(_ sender: Any) {
        let vc = AppUIViewControllers.signUpScreen()
        appNavigationCoordinator.pushUIKit(vc)
    }
    
    
}

extension SignInScreen {
    private func bindViewModel() {}
}

