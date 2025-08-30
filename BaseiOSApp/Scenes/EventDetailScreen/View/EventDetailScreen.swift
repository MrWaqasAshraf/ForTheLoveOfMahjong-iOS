//
//  EventDetailScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import UIKit

class EventDetailScreen: UIViewController {
    
    static let identifier = "EventDetailScreen"
    
    private var viewModel: EvenDetailViewModel
    
    init?(coder: NSCoder, viewModel: EvenDetailViewModel) {
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
        initialSetupforHeader(color: .clr_transparent_shade_1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialSetupforHeader(revertNavBar: true)
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .white
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  "Event Detail"
        titleLbl.titleLbl.textColor = .white
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .center, customView: titleLbl)]))
        
//        initialSetupforHeader(color: .clr_transparent_shade_1)
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    
}

extension EventDetailScreen {
    private func bindViewModel() {}
}

