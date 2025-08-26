//
//  SideMenuScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit

class SideMenuScreen: UIViewController {
    
    static let identifier = "SideMenuScreen"
    
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
    
    private func setupUiElements() {
        
    }
    
}

extension SideMenuScreen {
    
    private func bindViewModel() {
        
    }
    
}
