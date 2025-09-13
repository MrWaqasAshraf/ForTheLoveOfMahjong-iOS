//
//  EventsListScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 13/09/2025.
//

import UIKit

class EventsListScreen: UIViewController {
    
    static let identifier = "EventsListScreen"
    
    @IBOutlet weak var eventsListTable: UITableView!
    
    private var viewModel: EventsListViewModel
    
    init?(coder: NSCoder, viewModel: EventsListViewModel) {
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
        callApis()
    }
    
    private func callApis() {
        ActivityIndicator.shared.showActivityIndicator(view: view)
        viewModel.eventsListApi()
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  viewModel.screenTitle
        titleLbl.titleLbl.textColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]),  .init(position: .center, customView: titleLbl)]))
        
        eventsListTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        eventsListTable.showsVerticalScrollIndicator = false
        
        registerCell()
        
    }
    
    private func registerCell() {
        let cellNib: UINib = UINib(nibName: EventInfoCell.identifier, bundle: .main)
        eventsListTable.register(cellNib, forCellReuseIdentifier: EventInfoCell.identifier)
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    private func goBackToMap() {
        appNavigationCoordinator.pop()
    }
    
    //MARK: EventsAndActions
    @IBAction func searchFieldEditingChanged(_ sender: UITextField) {
        viewModel.searchEvents(searchText: sender.text)
    }
    
    
}

extension EventsListScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.eventsListResponse.value?.data?.events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventInfoCell.identifier, for: indexPath) as! EventInfoCell
        let data = viewModel.eventsListResponse.value?.data?.events?[indexPath.row]
        cell.configureCellWithEventData(data: data, flowtype: viewModel.eventsListType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
}

extension EventsListScreen {
    
    private func bindViewModel() {
        
        viewModel.eventsListResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            DispatchQueue.main.async {
                self?.eventsListTable.reloadData()
            }
            if response?.isSuccessful != true {
                GenericToast.showToast(message: response?.message ?? "")
            }
        }
        
    }
    
}
