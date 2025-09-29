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
        callApi()
    }
    
    private func callApi() {
        ActivityIndicator.shared.showActivityIndicator(view: view)
        viewModel.faqsListApi()
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  "FAQs"
        titleLbl.titleLbl.textColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]),  .init(position: .center, customView: titleLbl)]))
        
        let cellNib = UINib(nibName: FAQInfoCell.identifier, bundle: .main)
        faqsTableView.register(cellNib, forCellReuseIdentifier: FAQInfoCell.identifier)
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
}

extension FAQsListScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.faqsListResponse.value?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQInfoCell.identifier, for: indexPath) as! FAQInfoCell
        let data = viewModel.faqsListResponse.value?.data?[indexPath.row]
        cell.configureCell(data: data)
        cell.closure = { [weak self] in
            self?.viewModel.shouldExpandFaq(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isOnLast = indexPath.row == (viewModel.faqsListResponse.value?.data?.count ?? 0) - 1
        if isOnLast && !viewModel.isLast && !viewModel.isPaginating {
            ActivityIndicator.shared.showActivityIndicatorOnBottom(view: view)
            viewModel.faqsListApi(paginate: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension FAQsListScreen {
    
    private func bindViewModel() {
        
        viewModel.faqsListResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            DispatchQueue.main.async {
                self?.faqsTableView.reloadData()
            }
        }
        
    }
    
}
