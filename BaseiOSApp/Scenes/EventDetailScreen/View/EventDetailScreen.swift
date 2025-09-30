//
//  EventDetailScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import UIKit
import MapKit

class EventDetailScreen: UIViewController {
    
    static let identifier = "EventDetailScreen"
    
    @IBOutlet weak var shareBtnView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTypeLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventLocationNameLbl: UILabel!
    @IBOutlet weak var personNameLbl: UILabel!
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
//        viewModel.groupNotifier()
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
        
//        initialSetupforHeader(color: .clr_transparent_shade_1)
        
        shareBtnView.isHidden = !viewModel.showShareBtn
        mapEventDetailData(data: viewModel.eventDetail.value, firstLoad: true)
        
    }
    
    private func setupNabBar(barButtons: [BarButtonModel] = []) {
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: barButtons))
    }
    
    private func mapEventDetailData(data: MahjongEventData?, firstLoad: Bool = false) {
        
        eventTypeLbl.text = data?.type ?? "..."
        eventNameLbl.text = data?.name ?? "..."
        eventLocationLbl.text = data?.locationName ?? "..."
        eventLocationNameLbl.text = data?.address ?? "..."
        eventDescriptionLbl.text = data?.description ?? "N/A"
        contactLbl.text = data?.contact ?? "N/A"
        personNameLbl.text = data?.personName ?? "N/A"
        eventImage.getFullUrlImage(url: baseUrlDomain.dropLast(4).lowercased() + "\(data?.image ?? "")", placeHolderImage: .event_detail_image)
        
        
        if firstLoad {
            
            let titleLbl = ReusableLabelUI.fromNib()
            titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLbl.titleLbl.text =  "Event Detail"
            titleLbl.titleLbl.textColor = .white
            
            let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
            let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
            barBtn.tintColor = .white
            
            var allBarButtons: [BarButtonModel] = [.init(position: .left, barButtons: [barBtn]), .init(position: .center, customView: titleLbl)]
            
            
            if appUserData?.userID != nil {
                
                let img2 = UIImage.kebab_menu_icon.withRenderingMode(.alwaysTemplate)
                let actionImageEdit: UIImage = .edit_green_icon.withRenderingMode(.alwaysTemplate)
                actionImageEdit.withTintColor(.white)
                let actionImageDelete: UIImage = .trash_icon_system.withRenderingMode(.alwaysTemplate)
                actionImageDelete.withTintColor(.white)
                
                if appUserData?.role == "role" {
                    
                    let editAction = UIAction(title: "Edit", image: actionImageEdit) { [weak self] action in
                        print("Edit")
                        DispatchQueue.main.async {
                            guard let data = self?.viewModel.eventDetail.value else { return }
                            self?.navigateToAddEventScreenForEdit(data: data)
                        }
                    }
                    let deleteAction = UIAction(title: "Delete", image: actionImageDelete) { [weak self] action in
                        print("Delete")
                        DispatchQueue.main.async {
                            GenericAlert.showAlert(title: "Delete Event", message: "This event will be delete permanently. Are you sure?", actions: [.init(title: "Delete", style: .destructive), .init(title: "Cancel", style: .default)], controller: self) { _, btnIndex, _ in
                                if btnIndex == 0 {
                                    self?.eventDeleteApi()
                                }
                            }
                        }
                    }
                    let optionsMenu = UIMenu(children: [editAction, deleteAction])
                    let barBtn2 = UIBarButtonItem(title: nil, image: img2, primaryAction: nil, menu: optionsMenu)
                    barBtn2.tintColor = .white
                    allBarButtons.append(.init(position: .right, barButtons: [barBtn2]))
                    
                }
                else {
                    if appUserData?.userID == data?.user?.userInfoModel.id {
                        let editAction = UIAction(title: "Edit", image: actionImageEdit) { [weak self] action in
                            DispatchQueue.main.async {
                                guard let data = self?.viewModel.eventDetail.value else { return }
                                self?.navigateToAddEventScreenForEdit(data: data)
                            }
                        }
                        let deleteAction = UIAction(title: "Delete", image: actionImageDelete) { [weak self] action in
                            print("Delete")
                            DispatchQueue.main.async {
                                self?.deleteReasonDialog()
                            }
                        }
                        let optionsMenu = UIMenu(children: [editAction, deleteAction])
                        let barBtn2 = UIBarButtonItem(title: nil, image: img2, primaryAction: nil, menu: optionsMenu)
                        barBtn2.tintColor = .white
                        allBarButtons.append(.init(position: .right, barButtons: [barBtn2]))
                    }
                }
            }
            
            setupNabBar(barButtons: allBarButtons)
        }
        
        if appUserData?.userID != nil {
            
            
            if let remoteUserId = data?.user?.userInfoModel.id {
//                favouriteIconContainerView.isHidden = appUserData?.userID == remoteUserId
                favouriteIconContainerView.isHidden = false
            }
            else {
                favouriteIconContainerView.isHidden = true
            }
            
        }
        else {
            favouriteIconContainerView.isHidden = true
        }
        
        
        let isFavourite = data?.favouritedBy?.filter({ $0 == appUserData?.userID }).first != nil
        viewModel.isFavouriteEvent = isFavourite
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
    
    private func navigateToAddEventScreenForEdit(data: MahjongEventData) {
        let vc = AppUIViewControllers.addEventScreen(viewModel: EventAndFilterViewModel(eventDetailForEdit: data))
        appNavigationCoordinator.pushUIKit(vc)
    }
    
    private func eventDeleteApi() {
        DispatchQueue.main.async {
            ActivityIndicator.shared.showActivityIndicator(view: self.view)
        }
        viewModel.eventDeleteApi()
    }
    
    private func deleteReasonDialog() {
        GenericAlert.showAlert(title: "Reason for Deletion", message: "Please tell us why you want this event deleted", textFieldActions: [.init(identifier: 101, placeholder: "Enter delete reason")], actions: [.init(title: "Send Request", style: .default), .init(title: "Cancel", style: .default)], controller: self) { [weak self] _, btnIndex, textFields in
            
            if btnIndex == 0 {
                if let reasonField = textFields?.first {
                    if let text = reasonField.textFieldValue, !text.replacingOccurrences(of: " ", with: "").isEmpty {
                        self?.eventDeleteRequestApi(reason: text)
                    }
                    else {
                        GenericToast.showToast(message: "Reason is required")
                    }
                }
            }
            
        }
    }
    
    private func eventDeleteRequestApi(reason: String?) {
        DispatchQueue.main.async {
            ActivityIndicator.shared.showActivityIndicator(view: self.view)
        }
        viewModel.eventDeleteRequestApi(reason: reason)
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    //MARK: ButtonActions
    @IBAction func locationNavigateBtn(_ sender: Any) {
        let eventData = viewModel.eventDetail.value
        if let lat = eventData?.lat, let long = eventData?.lng {
            
            //Old
//            AppUrlHandler.openInputUrl(url: nil, type: .googleMap(LocationLinkDataModel(latitude: "\(lat)", longitude: "\(long)")))
            
            //New
//            let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            
            let address: [String: Any] = [
                "Street": eventData?.address ?? ""
                ]
            let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), addressDictionary: address)
            let mapItem = MKMapItem(placemark: placemark)
            let launchOptions: [String: Any] = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))]
            mapItem.openInMaps(launchOptions: launchOptions)
            
        }
    }
    
    
    @IBAction func markFavoruiteBtn(_ sender: Any) {
        viewModel.isFavouriteEvent.toggle()
        favouriteIcon.tintColor = viewModel.isFavouriteEvent ? .clr_primary_light : .clr_gray_1
        viewModel.toggleFavouriteApi()
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
        /*
         Mahjong invitation

         Event: <event name>

         Location: <google map link>

         Event dates:

         - <first date>
         - <nth date>
         */
        
        // text to share
        var shareText = "Mahjong invitation"
        
        let eventData = viewModel.eventDetail.value
        
        if let eventname = eventData?.name {
            shareText += "\n\nEvent: \(eventname)"
        }
        
        if let address = eventData?.address {
            shareText += "\n\nAddress: \(address)"
        }
        
        if let lat = eventData?.lat, let long = eventData?.lng {
            let locLink = LocationLinkDataModel(latitude: "\(lat)", longitude: "\(long)")
            shareText += "\n\nLocation: \(locLink.googleMapLink)"
        }
        
        if let contact = eventData?.contact {
            shareText += "\n\nContact Info: \(contact)"
        }
        
        if let eventDates = eventData?.dateTime {
            
            if !eventDates.isEmpty {
                shareText += "\n\nEvent Date & Timings:\n"
                for date in eventDates {
                    shareText += "\n• \(date)"
                }
            }
            
        }
        
        
        // set up activity view controller
        let textToShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
}

extension EventDetailScreen {
    
    private func bindViewModel() {
        
        viewModel.eventDeleteResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            GenericToast.showToast(message: response?.message ?? "")
            if response?.isSuccessful == true {
                DispatchQueue.main.async {
                    self?.goBack()
                }
            }
        }
        
        viewModel.eventDeleteRequestResponse.bind { response in
            ActivityIndicator.shared.removeActivityIndicator()
            GenericToast.showToast(message: response?.message ?? "")
        }
        
        viewModel.eventDetail.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            DispatchQueue.main.async {
                self?.mapEventDetailData(data: response)
            }
        }
        
        viewModel.favoruiteEventResponse.bind { response in
            if response?.isSuccessful != true {
                GenericToast.showToast(message: response?.message ?? "")
            }
        }
        
    }
    
}

