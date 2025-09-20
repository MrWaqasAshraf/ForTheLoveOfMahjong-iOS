//
//  SideMenuScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit

class SideMenuScreen: UIViewController {
    
    static let identifier = "SideMenuScreen"
    
    @IBOutlet weak var sideMenuTableView: UITableView!
    private var viewModel: SideMenuViewModel
    
    init?(coder: NSCoder, viewModel: SideMenuViewModel) {
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
        viewModel.checkLogoutStatus()
        DispatchQueue.main.async {
            self.sideMenuTableView.reloadData()
        }
    }
    
    private func setupUiElements() {
        
        let cellNib = UINib(nibName: SideMenuOptionCell.identifier, bundle: .main)
        sideMenuTableView.register(cellNib, forCellReuseIdentifier: SideMenuOptionCell.identifier)
        
    }
    
    //MARK: ButtonActions
    @IBAction func linkBtn(_ sender: Any) {
        AppUrlHandler.openInputUrl(url: "https://www.msmahjongg.com", type: .link)
    }
    
    
}

extension SideMenuScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sideMenuOptionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuOptionCell.identifier, for: indexPath) as! SideMenuOptionCell
        let data = viewModel.sideMenuOptionsList[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.sideMenuOptionsList[indexPath.row]
        switch data.slug {
        case .profile:
            if let appUserData {
                dismiss(animated: true)
                let vc = AppUIViewControllers.profileScreen()
                appNavigationCoordinator.pushUIKit(vc)
            }
            else {
                dismiss(animated: true)
                let vc = AppUIViewControllers.signInScreen()
                appNavigationCoordinator.pushUIKit(vc)
            }
        case .events:
            if let appUserData {
                dismiss(animated: true)
                let vc = AppUIViewControllers.eventsListScreen(viewModel: EventsListViewModel(screenTitle: "Events", eventsListType: .allEvents))
                appNavigationCoordinator.pushUIKit(vc)
            }
            else {
                dismiss(animated: true)
                let vc = AppUIViewControllers.signInScreen()
                appNavigationCoordinator.pushUIKit(vc)
            }
        case .favorite:
            if let appUserData {
                dismiss(animated: true)
                let vc = AppUIViewControllers.eventsListScreen(viewModel: EventsListViewModel(screenTitle: "Favourites", eventsListType: .favourites))
                appNavigationCoordinator.pushUIKit(vc)
            }
            else {
                dismiss(animated: true)
                let vc = AppUIViewControllers.signInScreen()
                appNavigationCoordinator.pushUIKit(vc)
            }
        case .logout:
            
            let lbl = ReusableLabelUI.fromNib()
            lbl.titleLbl.text = "Are you sure you want to logout?"
            AppDialogUI.addDialogView(headerTitle: "Logout", midViews: [lbl], buttons: [.init("", style: .empty, height: 40), .init("Cancel", style: .cancel, height: 40), .init("Logout", style: .appDefault, height: 40)]) { [weak self] btnIndex, dialog in
                if btnIndex == 2 {
                    UserDefaultsHelper.removeUserAndToken()
                    self?.viewModel.checkLogoutStatus()
                    DispatchQueue.main.async {
                        self?.sideMenuTableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    dialog.removeFromSuperview()
                }
            }
            
        case .darkMode:
            print("TBD")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    
}

extension SideMenuScreen {
    
    private func bindViewModel() {
        
    }
    
}
