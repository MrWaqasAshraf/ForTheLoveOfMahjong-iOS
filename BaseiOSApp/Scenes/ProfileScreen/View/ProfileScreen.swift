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
        
        let img2 = UIImage.trash_icon_system.withRenderingMode(.alwaysTemplate)
        let barBtn2 = UIBarButtonItem(image: img2, style: .plain, target: self, action: #selector(deleteProfile))
        barBtn2.tintColor = .red
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]),
                                                                                               .init(position: .right, barButtons: [barBtn2])]))
        
        emailLbl.text = appUserData?.email ?? "..."
        firstNameLbl.text = appUserData?.firstName ?? "..."
        lastNameLbl.text = appUserData?.lastName ?? "..."
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    @objc
    private func deleteProfile() {
        GenericAlert.showAlert(title: "Delete Profile", message: "This will delete your profile and remove all the events you created, do you want to continue?", actions: [.init(title: "Yes", style: .destructive), .init(title: "No", style: .default)], controller: self) { _, btnIndex, _ in
            if btnIndex == 0 {
                print("Delete profile api")
            }
        }
    }
    
    @IBAction func backToHomeBtn(_ sender: Any) {
        goBack()
    }
    
    
    
}
