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
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var uploadImageContainerView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var editImageIcon: UIImageView!
    @IBOutlet weak var selectedDatesLbl: UILabel!
    @IBOutlet weak var editDatesIcon: UIImageView!
    @IBOutlet weak var selectDateTitleLbl: UILabel!
    
    private var imagePicker = UIImagePickerController()
    
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
        setupImagePicker()
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
        MahjongFileManager.shared.removeFile(path: TempFileURLs.tournamentImage)
        appNavigationCoordinator.pop()
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
            selectedDatesLbl.text = "Select date"
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
    
    //MARK: ButtonActions
    @IBAction func selectAddressBtn(_ sender: Any) {
        let vc = AppUIViewControllers.selectEventLocationScreen()
        vc.closure = { [weak self] selectedAddress, fullAddress, coordinates in
            DispatchQueue.main.async {
                self?.addressField.text = fullAddress
            }
        }
        appNavigationCoordinator.pushUIKit(vc)
    }
    
    @IBAction func uploadImageBtn(_ sender: Any) {
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
        DatePickerUI.addPickerView(parentView: view, datePickerMode: .dateAndTime, minimumTime: .now) { [weak self] pickerUi, btnIndex, selectedDateInStr, selectedDateInDate in
            if let selectedDateInDate {
                print("Selected date: \(selectedDateInDate)")
                print("Selecte time: \(selectedDateInDate.convertToDateString(dateFormat: "HH:mm:ss"))")
                self?.viewModel.addSelectedDates(date: SelectedEventDateTime(dateTime: selectedDateInDate))
            }
            DispatchQueue.main.async {
                pickerUi.removeFromSuperview()
            }
        }
    }
    
    @IBAction func addEventBtn(_ sender: Any) {
        let createAndValidatePayload = viewModel.createAndValidatePayload(name: eventNameField.text, locationName: locationNameField.text, address: addressField.text, contact: contactField.text, description: descriptionField.text ?? "")
        if createAndValidatePayload.0 {
//            ActivityIndicator.shared.showActivityIndicator(view: view)
            viewModel.createMahjonEventApi(parameters: createAndValidatePayload.2)
        }
        else {
            GenericToast.showToast(message: createAndValidatePayload.1 ?? "")
        }
    }
    
    @IBAction func editDatesBtn(_ sender: Any) {
        if let selectedEventDates = viewModel.selectedEventDates.value, !selectedEventDates.isEmpty {
            showEditDatesScreen()
        }
    }
    
    
}

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
            editImageIcon.isHidden = false
            selectedImageView.image = capturedImage
            if let imageData = capturedImage.pngData(){
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
        
        viewModel.manageEventResponse.bind { [weak self] response in
            ActivityIndicator.shared.removeActivityIndicator()
            GenericToast.showToast(message: response?.message ?? "")
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
        
    }
    
}

