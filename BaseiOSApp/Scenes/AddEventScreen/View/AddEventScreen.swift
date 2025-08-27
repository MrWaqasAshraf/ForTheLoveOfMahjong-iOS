//
//  AddEventScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 27/08/2025.
//

import UIKit

class AddEventScreen: UIViewController {
    
    static let identifier = "AddEventScreen"
    
    @IBOutlet weak var eventTypesCollectionView: UICollectionView!
    @IBOutlet weak var eventTypesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var eventCategoriesCollectionViewHeight: NSLayoutConstraint!
    
    private var viewModel: EventAndFilterViewModel
    
    init?(coder: NSCoder, viewModel: EventAndFilterViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationCoordinator.shouldShowNavController(show: true, animted: false)
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
        
        viewModel.eventTypes.value?.removeAll(where: { $0.eventSlug == .all })
        viewModel.eventCategories.value?.removeAll(where: { $0.eventCategorySlug == .all })
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  "Add Event"
        titleLbl.titleLbl.textColor = .black
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .center, customView: titleLbl)]))
        
        let cellNib = UINib(nibName: CustomOptionCell.identifier, bundle: .main)
        eventTypesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
        eventCategoriesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
}

extension AddEventScreen: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

extension AddEventScreen {
    
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

