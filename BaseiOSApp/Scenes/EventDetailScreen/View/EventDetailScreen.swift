//
//  EventDetailScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import UIKit

class EventDetailScreen: UIViewController {
    
    static let identifier = "EventDetailScreen"
    
    @IBOutlet weak var eventTypeLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventLocationNameLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var eventDescriptionLbl: UILabel!
    @IBOutlet weak var datesStackView: UIStackView!
    @IBOutlet weak var favouriteIconContainerView: UIView!
    @IBOutlet weak var favouriteIcon: UIImageView!
    
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
        callApis()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSetupforHeader(color: .clr_transparent_shade_1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        initialSetupforHeader(revertNavBar: true)
    }
    
    private func callApis() {
        ActivityIndicator.shared.showActivityIndicator(view: view)
        viewModel.mahjongEventDetailApi()
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
        
        mapEventDetailData(data: viewModel.eventDetail.value)
        
    }
    
    private func mapEventDetailData(data: MahjongEventData?) {
        
        eventTypeLbl.text = data?.type ?? "..."
        eventNameLbl.text = data?.name ?? "..."
        eventLocationLbl.text = data?.locationName ?? "..."
        eventLocationNameLbl.text = data?.address ?? "..."
        eventDescriptionLbl.text = data?.description ?? "N/A"
        contactLbl.text = data?.contact ?? "N/A"
        
        if let remoteUserId = data?.user?.id {
            favouriteIconContainerView.isHidden = appUserData?.userID == remoteUserId
        }
        
        let isFavourite = data?.favouritedBy?.filter({ $0 == appUserData?.userID }).first != nil
        favouriteIcon.tintColor = isFavourite ? .clr_primary_light : .clr_gray_1
        
        if let dates = data?.dateTime {
            let isEmpty = dates.isEmpty
            if !isEmpty {
                datesStackView.removeAllSubviews()
            }
            for (index, date) in dates.enumerated() {
                let dateUi = BulletPointUI.fromNib()
                dateUi.titleLbl.text = date
                let addSeparator = index > 0
                if addSeparator {
                    let seperator = VerticalLineSeparatorUI.fromNib()
                    datesStackView.addArrangedSubview(seperator)
                }
                datesStackView.addArrangedSubview(dateUi)
            }
            
        }
        else {
            datesStackView.removeAllSubviews()
            let seperator = VerticalLineSeparatorUI.fromNib()
            seperator.separatorLineView.isHidden = true
            datesStackView.addArrangedSubview(seperator)
        }
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    //MARK: ButtonActions
    @IBAction func markFavoruiteBtn(_ sender: Any) {
        
    }
    
    
}

extension EventDetailScreen {
    
    private func bindViewModel() {
        
        viewModel.eventDetail.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            DispatchQueue.main.async {
                self?.mapEventDetailData(data: response)
            }
        }
        
    }
    
}

