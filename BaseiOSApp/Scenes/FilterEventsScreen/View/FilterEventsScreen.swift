//
//  FilterEventsScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit

class FilterEventsScreen: UIViewController {
    
    static let identifier = "FilterEventsScreen"
    
    @IBOutlet weak var eventTypesCollectionView: UICollectionView!
    @IBOutlet weak var eventTypesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var eventCategoriesCollectionViewHeight: NSLayoutConstraint!
    
    var closure: ((_ eventType: CustomOptionModel?, _ category: CustomOptionModel?)->())? = nil
    
    private var viewModel: EventAndFilterViewModel
    
    init?(coder: NSCoder, viewModel: EventAndFilterViewModel) {
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
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            self.eventTypesCollectionViewHeight.constant = self.eventTypesCollectionView.contentSize.height
            self.eventCategoriesCollectionViewHeight.constant = self.eventCategoriesCollectionView.contentSize.height
        }
    }
    
    private func setupUiElements() {
        
        let cellNib = UINib(nibName: CustomOptionCell.identifier, bundle: .main)
        eventTypesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
        eventCategoriesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
        
    }
    
    //MARK: ButtonActions
    @IBAction func applyBtn(_ sender: Any) {
        if let closure {
            closure(viewModel.selectedEventType.value, viewModel.selectedCategoryType.value)
            dismiss(animated: true)
        }
    }
    
    
}

extension FilterEventsScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == eventTypesCollectionView {
            return viewModel.eventTypes.value?.count ?? 0
        }
        else {
            return viewModel.eventCategories.value?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomOptionCell.identifier, for: indexPath) as! CustomOptionCell
        if collectionView == eventTypesCollectionView {
            let data = viewModel.eventTypes.value?[indexPath.row]
            cell.configureCell(data: data)
        }
        else {
            let data = viewModel.eventCategories.value?[indexPath.row]
            cell.configureCell(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == eventTypesCollectionView {
            viewModel.shouldSelectEventType(indexPath: indexPath)
        }
        else {
            viewModel.shouldSelectEventCategory(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 25)
    }
    
}

extension FilterEventsScreen {
    
    private func bindViewModel() {
        
        viewModel.eventTypes.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.eventTypesCollectionView.reloadData()
            }
        }
        
        viewModel.eventCategories.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.eventCategoriesCollectionView.reloadData()
            }
        }
        
    }
    
}
