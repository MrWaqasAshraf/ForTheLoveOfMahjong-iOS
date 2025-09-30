//
//  AddEventScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 27/08/2025.
//

import UIKit
import Photos
import QuickLookThumbnailing
import SDWebImage

class AddEventScreen: UIViewController {
    
    static let identifier = "AddEventScreen"
    
    @IBOutlet weak var eventTypesCollectionView: UICollectionView!
    @IBOutlet weak var eventTypesCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var eventCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var eventCategoriesCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var uploadImageContainerView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var editImageIcon: UIImageView!
    @IBOutlet weak var selectedDatesLbl: UILabel!
    @IBOutlet weak var editDatesIcon: UIImageView!
    @IBOutlet weak var selectDateTitleLbl: UILabel!
    @IBOutlet weak var selectImageBtn: UIButton!
    
    //Placeholders
    @IBOutlet weak var placeholderCameraIcon: UIImageView!
    @IBOutlet weak var placeholderUploadLbl: UILabel!
    
    private var imagePicker = UIImagePickerController()
    
    var closure: (()->())? = nil
    
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
        setupImagePicker()
        setupUiElements()
    }
    
    private func setupImagePicker() {
        //remove any image saved locally
        MahjongFileManager.shared.removeFile(path: TempFileURLs.tournamentImage)
        
        let imageUrl = MahjongFileManager.shared.readFile(path: TempFileURLs.tournamentImage)
        selectedImageView.sd_setImage(with: imageUrl)
        
        imagePicker.delegate = self
//        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)! //For videos
        imagePicker.allowsEditing = true
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
        
        let img2 = UIImage.info_icon_system.withRenderingMode(.alwaysTemplate)
        let barBtn2 = UIBarButtonItem(image: img2, style: .plain, target: self, action: #selector(showDialogForAutoApprovedEvents))
        barBtn2.tintColor = .black
        
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  "Add Event"
        titleLbl.titleLbl.textColor = .black
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .center, customView: titleLbl), .init(position: .right, barButtons: [barBtn2])]))
        
        let cellNib = UINib(nibName: CustomOptionCell.identifier, bundle: .main)
        eventTypesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
        eventCategoriesCollectionView.register(cellNib, forCellWithReuseIdentifier: CustomOptionCell.identifier)
        
        if let eventData = viewModel.eventDetailForEdit {
            mapEventData(data: eventData)
        }
        
    }
    
    private func mapEventData(data: MahjongEventData) {
        eventNameField.text = data.name
        locationNameField.text = data.locationName
        addressField.text = data.address
        nameField.text = data.personName
        contactField.text = data.contact
        descriptionField.text = data.description
        shouldShowPlaceholderUis(show: false)
        editImageIcon.isHidden = true
        selectImageBtn.isEnabled = false
        print("Full image: \(baseUrlDomain.dropLast(4).lowercased())\(data.image ?? "")")
        selectedImageView.getFullUrlImage(url: "\(baseUrlDomain.dropLast(4).lowercased())\(data.image ?? "")", placeHolderImage: .placeholderImg)
        mapSelectedDates()
    }
    
    @objc
    private func goBack() {
        MahjongFileManager.shared.removeFile(path: TempFileURLs.tournamentImage)
        appNavigationCoordinator.pop()
    }
    
    private func goBackToMainScreen() {
        MahjongFileManager.shared.removeFile(path: TempFileURLs.tournamentImage)
        appNavigationCoordinator.popToSpecificVc(vc: MainMapScreen.self)
    }
    
    private func generateThumbnailRepresentations(fileUrl: URL) {

        let size: CGSize = CGSize(width: 60, height: 90)
        let scale = UIScreen.main.scale
        
        // Create the thumbnail request.
        let request = QLThumbnailGenerator.Request(fileAt: fileUrl,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .all)
        
        // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { [weak self] (thumbnail, type, error) in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    // Handle the error case gracefully.
                    print("Thumbnail error: \(String(describing: error?.localizedDescription))")
                } else {
                    // Display the thumbnail that you created.
                    self?.editImageIcon.isHidden = false
                    self?.selectedImageView.image = thumbnail?.uiImage
                }
            }
        }
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType){
        imagePicker.sourceType = sourceType
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    private func mapSelectedDates() {
        let selectedDates = viewModel.compileSelectedDatesForLabel()
        selectedDatesLbl.text = selectedDates
        if selectedDates.isEmpty {
            selectedDatesLbl.text = "Select date"
            selectedDatesLbl.textColor = .clr_gray_dk
            editDatesIcon.isHidden = true
        }
        else {
            selectedDatesLbl.textColor = .label
            editDatesIcon.isHidden = false
        }
    }
    
    private func setupEventTypeViews(eventType: EventOptionSlug) {
        switch eventType {
        case .all, .noneOption:
            print("Do nothing")
        case .tournament:
            print("tournament")
            selectDateTitleLbl.text = "Select multiple dates"
        case .game:
            print("game")
            selectDateTitleLbl.text = "Select multiple dates"
        }
    }
    
    private func addSelectedDates(date: SelectedEventDateTime) {
        let eventType = viewModel.selectedEventType.value
        if eventType?.eventSlug == .tournament {
            viewModel.selectedEventDates.value?.append(date)
        }
        else if eventType?.eventSlug == .game {
            viewModel.selectedEventDates.value = [date]
        }
    }
    
    private func showEditDatesScreen(){
        let vc = AppUIViewControllers.editDatesScreen(viewModel: EditDatesViewModel(selectedDates: viewModel.selectedEventDates.value ?? []))
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        vc.closure = { [weak self] dates in
            self?.viewModel.selectedEventDates.value = dates
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func endEditing() {
        view.endEditing(true)
    }
    
    private func shouldShowPlaceholderUis(show: Bool) {
        placeholderUploadLbl.isHidden = !show
        placeholderCameraIcon.isHidden = !show
    }
    
    private func showTimePicker(isStartTime: Bool, title: String) {
        if !isStartTime {
            ActivityIndicator.shared.removeActivityIndicator()
        }
        TimePickerUI.addPickerView(title: title) { [weak self] pickerUi, btnIndex, selectedTimeInString, selectTimeinDateFormat in
            if let selectTimeinDateFormat {
                print(selectTimeinDateFormat)
                if isStartTime {
                    self?.viewModel.selectedEventDayAndTimeForGame.value?.startTime = selectTimeinDateFormat
                    ActivityIndicator.shared.showActivityIndicator(view: self?.view ?? .init())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self?.showTimePicker(isStartTime: false, title: "Game End time")
                    }
                }
                else {
                    if let startTimeInMilli = self?.viewModel.selectedEventDayAndTimeForGame.value?.startTime?.millisecondsSince1970 {
                        let endTimeMilli = selectTimeinDateFormat.millisecondsSince1970
                        if endTimeMilli >= startTimeInMilli {
                            self?.viewModel.selectedEventDayAndTimeForGame.value?.endTime = selectTimeinDateFormat
                        }
                        else {
                            GenericToast.showToast(message: "End time cannot be smaller than start time")
                        }
                    }
                    else {
                        GenericToast.showToast(message: "Invalid start time set")
                    }
                    
                }
            }
            DispatchQueue.main.async {
                pickerUi.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func showDialogForAutoApprovedEvents() {
        let autoApprovedEvents: String = """
• You can post up to \(allowedEventsNumber) events without approval.
• Additional events will be approved within 24 hours by the admin.
• Events take 10–15 minutes to appear on the app after posting.
"""
        GenericAlert.showAlert(title: "Mahjong Events", message: autoApprovedEvents, actions: [.init(title: "Close", style: .default)], controller: self) { _, _, _ in }
    }
    
    //MARK: ButtonActions
    @IBAction func selectAddressBtn(_ sender: Any) {
        endEditing()
        
        let vc = AppUIViewControllers.addLocationSearchScreen()
        vc.closure = { [weak self] selectedAddress in
            
            if let coordinates = selectedAddress.coordinates {
                self?.viewModel.eventLocationCoordinates = EventLocationInfo(lat: coordinates.latitude, long: coordinates.longitude, address: (selectedAddress.locationName == "" ? "" : "\(selectedAddress.locationName ?? ""), " + selectedAddress.location))
            }
            
            DispatchQueue.main.async {
                self?.addressField.text = selectedAddress.locationName == "" ? "" : "\(selectedAddress.locationName ?? ""), " + selectedAddress.location
            }
        }
        appNavigationCoordinator.pushUIKit(vc)
        
        
    }
    
    @IBAction func chooseOnMap(_ sender: Any) {
        endEditing()
        let vc = AppUIViewControllers.selectEventLocationScreen()
        vc.closure = { [weak self] selectedAddress, fullAddress, coordinates in
            
            if let coordinates {
                self?.viewModel.eventLocationCoordinates = EventLocationInfo(lat: coordinates.latitude, long: coordinates.longitude, address: fullAddress ?? "Game adress")
            }
            
            DispatchQueue.main.async {
                self?.addressField.text = fullAddress
            }
            
        }
        appNavigationCoordinator.pushUIKit(vc)
    }
    
    @IBAction func uploadImageBtn(_ sender: Any) {
        endEditing()
        PhotoOptionsBottomSheet.showBottomSheet(parentView: view) { [weak self] btnIndex, bottomSheet in
            if btnIndex == 0{
                DispatchQueue.main.async {
                    self?.openImagePicker(sourceType: .camera)
                }
            }
            else if btnIndex == 1{
                DispatchQueue.main.async {
                    self?.openImagePicker(sourceType: .savedPhotosAlbum)
                }
            }
            bottomSheet.removeFromSuperview()
        }
    }
    
    @IBAction func selectEventDatesBtn(_ sender: Any) {
        endEditing()
        if viewModel.selectedEventType.value?.eventSlug == .tournament {
            DatePickerUI.addPickerView(parentView: view, datePickerMode: .dateAndTime, minimumTime: .now) { [weak self] pickerUi, btnIndex, selectedDateInStr, selectedDateInDate in
                if let selectedDateInDate {
                    print("Selected date: \(selectedDateInDate)")
                    print("Selecte time: \(selectedDateInDate.convertToDateString(dateFormat: "HH:mm:ss"))")
                    var selectedDt = SelectedEventDateTime(type: .tournament, dateTime: selectedDateInDate)
                    selectedDt.dateTime = selectedDateInDate
                    self?.viewModel.addSelectedDates(date: selectedDt)
                }
                DispatchQueue.main.async {
                    pickerUi.removeFromSuperview()
                }
            }
        }
        else if viewModel.selectedEventType.value?.eventSlug == .game {
            DispatchQueue.main.async {
                let daysView = DaySelectionUI.fromNib()
                daysView.closure = { [weak self] selectedDay in
                    if let selectedDay {
                        print(selectedDay)
                        self?.viewModel.selectedEventDayAndTimeForGame.value = SelectedEventDateTime(type: .game, dateTime: Date(), selectedDay: selectedDay.optionValue)
                        DispatchQueue.main.async {
                            self?.showTimePicker(isStartTime: true, title: "Game Start time")
                        }
                    }
                }
                daysView.frame = self.view.bounds
                self.view.addSubview(daysView)
            }
            
        }
        
    }
    
    @IBAction func addEventBtn(_ sender: Any) {
        
        let createAndValidatePayload = viewModel.createAndValidatePayload(name: eventNameField.text, contactName: nameField.text, locationName: locationNameField.text, address: addressField.text, contact: contactField.text, description: descriptionField.text ?? "")
        if createAndValidatePayload.0 {
            print("params are: \(createAndValidatePayload.2)")
            ActivityIndicator.shared.showActivityIndicator(view: view)
            viewModel.createMahjonEventApi(parameters: createAndValidatePayload.2)
        }
        else {
            GenericToast.showToast(message: createAndValidatePayload.1 ?? "")
        }
        
    }
    
    @IBAction func editDatesBtn(_ sender: Any) {
        
        if let selectedEventDates = viewModel.selectedEventDates.value, !selectedEventDates.isEmpty {
            endEditing()
            showEditDatesScreen()
        }
    }
    
    
}

//extension AddEventScreen: UITextFieldDelegate {
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == contactField {
//            // Define the allowed characters
//            let allowedCharacters = NSCharacterSet(charactersIn: "1234567890+-() ")
//            
//            // Create a character set from the replacement string (the new character(s) being typed)
//            let characterSet = CharacterSet(charactersIn: string)
//            
//            // Check if all characters in the replacement string are within the allowed characters
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//        return true
//    }
//    
//}

extension AddEventScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Gallery image capture
        //        if let capturedImageUrl = info[.imageURL] as? URL{
        //            adImage.sd_setImage(with: capturedImageUrl)
        //            viewModel.imageUrls = [capturedImageUrl]
        //        }
        
        if let assetUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            print("Media url: \(assetUrl)")
        }
        
        //Camera image capture
        if let capturedImage = info[.editedImage] as? UIImage {
            shouldShowPlaceholderUis(show: false)
            editImageIcon.isHidden = false
            selectedImageView.image = capturedImage
//            if let imageData = capturedImage.pngData() {
            if let imageData = capturedImage.jpegData(compressionQuality: 0.6) {
                let isSaved: Bool = MahjongFileManager.shared.addfileToLocalFiles(fileData: imageData, fileLocationUrl: TempFileURLs.tournamentImage)
                if !isSaved{
                    GenericToast.showToast(message: "Some issue occurred")
                }
                if let imageUrl = MahjongFileManager.shared.readFile(path: TempFileURLs.tournamentImage){
                    viewModel.imageUrls = [imageUrl]
                    print("Tournament image added: \(String(describing: viewModel.imageUrls))")
                }
            }
        }
        else if let assetUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            shouldShowPlaceholderUis(show: false)
            let type = assetUrl.pathExtension           //e.g: MOV
            generateThumbnailRepresentations(fileUrl: assetUrl)
            print("video url: \(assetUrl): location url \(assetUrl.absoluteString), type: \(type)")
            viewModel.imageUrls = [assetUrl]
        }
        
        
//        uploadImageBTN.setImage(nil, for: .normal)
//        uploadImageBTN.setTitle("", for: .normal)
        
        picker.dismiss(animated: true)
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
            cell.configureCell(data: data, forCategory: true)
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
        
        viewModel.manageAddEventResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            if response?.isSuccessful == true {
                DispatchQueue.main.async {
                    self?.goBackToMainScreen()
                }
            }
        }
        
        viewModel.manageEventResponse.bind { [weak self] response in
            
            ActivityIndicator.shared.removeActivityIndicator()
            GenericToast.showToast(message: response?.message ?? "")
            if response?.isSuccessful == true {
                if let closure = self?.closure {
                    closure()
                }
                DispatchQueue.main.async {
                    self?.goBackToMainScreen()
                }
            }
            
        }
        
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
        
        viewModel.selectedEventType.bind { [weak self] selectedEventType in
            guard let selectedEventType, let slug = selectedEventType.eventSlug else { return }
            DispatchQueue.main.async {
                self?.setupEventTypeViews(eventType: slug)
            }
        }
        
        viewModel.selectedEventDates.bind { [weak self] selectedDates in
            DispatchQueue.main.async {
                self?.mapSelectedDates()
            }
        }
        
        viewModel.selectedEventDayAndTimeForGame.bind { [weak self] data in
            var allSet: Int = 0
            if let data {
                if let day = data.selectedDay {
                    allSet += 1
                }
                if let startTime = data.startTime {
                    allSet += 1
                }
                if let endTime = data.endTime {
                    allSet += 1
                }
                if allSet == 3 {
                    self?.viewModel.selectedEventDates.value?.append(data)
                }
            }
            
        }
        
    }
    
}

