//
//  ProfileScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 08/09/2025.
//

import UIKit

class ProfileScreen: UIViewController {
    
    static let identifier = "ProfileScreen"
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    private var viewModel: ProfileScreenViewModel
    
    init?(coder: NSCoder, viewModel: ProfileScreenViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiElements()
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn])]))
        
        emailLbl.text = appUserData?.email ?? "..."
        firstNameLbl.text = appUserData?.firstName ?? "..."
        lastNameLbl.text = appUserData?.lastName ?? "..."
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    @IBAction func backToHomeBtn(_ sender: Any) {
        goBack()
    }
    
    
    
}
