//
//  FilterEventsScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit

class FilterEventsScreen: UIViewController {
    
    static let identifier = "FilterEventsScreen"
    
    private var viewModel: FilterEventsViewModel
    
    init?(coder: NSCoder, viewModel: FilterEventsViewModel) {
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

extension FilterEventsScreen {
    
    private func bindViewModel() {
        
    }
    
}
