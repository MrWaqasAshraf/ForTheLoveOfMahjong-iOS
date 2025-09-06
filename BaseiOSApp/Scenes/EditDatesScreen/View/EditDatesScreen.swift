//
//  EditDatesScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 06/09/2025.
//

import UIKit

class EditDatesScreen: UIViewController {
    
    static let identifier = "EditDatesScreen"
    
    @IBOutlet weak var navigationBar: UIStackView!
    @IBOutlet weak var eventDatesTableView: UITableView!
    
    var closure: (([SelectedEventDateTime]?)->())? = nil
    
    private var viewModel: EditDatesViewModel
    
    init?(coder: NSCoder, viewModel: EditDatesViewModel) {
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
        
        CustomNavigationBar.addNavBar(parentView: navigationBar, showLeadBtn: false, insert: true, title: "Selected Dates", titleAlignment: .center, trailingImage: .xMarkUnFilledIconSystem, trailingImageTintColor: .clr_black, backgroundColor: .white) { [weak self] btnIndex, _ in
            if btnIndex == 1 {
                DispatchQueue.main.async {
                    self?.goBack()
                }
            }
        }
        
        registerCell()
        
    }
    
    private func registerCell() {
        let cellNib = UINib(nibName: MahjongEventDateCell.identifier, bundle: .main)
        eventDatesTableView.register(cellNib, forCellReuseIdentifier: MahjongEventDateCell.identifier)
    }
    
    private func goBack() {
        dismiss(animated: true)
    }
    
}

extension EditDatesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.selectedDates.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MahjongEventDateCell.identifier, for: indexPath) as!
        MahjongEventDateCell
        let data = viewModel.selectedDates.value?[indexPath.row]
        cell.configureCell(data: data)
        cell.closure = { [weak self] in
            self?.viewModel.removeDate(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    
}

extension EditDatesScreen {
    
    private func bindViewModel() {
        
        viewModel.selectedDates.bind { [weak self] dates in
            let isEmpty: Bool = dates?.isEmpty ?? true
            if let closure = self?.closure {
                closure(dates)
            }
            DispatchQueue.main.async {
                self?.eventDatesTableView.reloadData()
                if isEmpty {
                    self?.goBack()
                }
            }
        }
        
    }
    
}
