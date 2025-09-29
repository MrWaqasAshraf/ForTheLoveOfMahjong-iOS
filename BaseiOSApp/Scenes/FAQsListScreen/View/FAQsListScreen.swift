//
//  FAQsListScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/09/2025.
//

import UIKit

class FAQsListScreen: UIViewController {
    
    static let identifier = "FAQsListScreen"
    
    @IBOutlet weak var faqsTableView: UITableView!
    
    private var viewModel: FAQsViewModel
    
    init?(coder: NSCoder, viewModel: FAQsViewModel) {
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

extension FAQsListScreen {
    
    private func bindViewModel() {
        
    }
    
}
