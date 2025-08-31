//
//  MainMapScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import UIKit
import SideMenu
import GoogleMaps
import GooglePlaces
import CoreLocation

class MainMapScreen: UIViewController {
    
    static let identifier = "MainMapScreen"
    
    private var sideMenuVc: SideMenuNavigationController?
    @IBOutlet weak var googleMapView: UIView!
    
    //Google maps
    private var mapView: GMSMapView?
    
    private var fetcher: GMSAutocompleteFetcher?
    private var placesClient: GMSPlacesClient = GMSPlacesClient()
    private var googlePlacesSearchController: GMSAutocompleteViewController = GMSAutocompleteViewController()
    
    private var workItem: DispatchWorkItem?
    private let customQueue = DispatchQueue(label:"myOwnQueue")
    
    private var viewModel: MainMapViewModel
    
    init?(coder: NSCoder, viewModel: MainMapViewModel) {
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
        setupGoogleMap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.addMarkers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationCoordinator.shouldShowNavController(show: true, animted: false)
    }
    
    private func setupUiElements() {
        
        //Setup side menu
        let vc = AppUIViewControllers.sideMenuScreen()
        sideMenuVc = AppUIViewControllers.setupSideMenu(vc: vc)
        sideMenuVc?.setNavigationBarHidden(true, animated: true)
        //         sideMenuVc?.menuWidth = view.bounds.width - 50
        sideMenuVc?.menuWidth = 280
        SideMenuManager.default.leftMenuNavigationController = sideMenuVc
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        
        //Setup nav bar
        let img: UIImage = .hamburgerIconSystem.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(showSideMenuScreen))
        barBtn.tintColor = .black
        // 1. Create a UIButton
        let customButton = UIButton(type: .custom)
        let img2: UIImage = .filterRoundIcon.withRenderingMode(.alwaysOriginal)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.setImage(img2, for: .normal)
        customButton.addTarget(self, action:  #selector(filterEventsScreen), for: .touchUpInside)
//        let barBtn2 = UIBarButtonItem(image: img2, style: .plain, target: self, action: #selector(filterEventsScreen))
        let barBtn2 = UIBarButtonItem(customView: customButton)
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]), .init(position: .right, barButtons: [barBtn2])]))
        
    }
    
    private func setupLocationManager(){
        
        //Setup core location
        appLocationManager.delegate = self
        appLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 2
        
        customQueue.async {
            if CLLocationManager.locationServicesEnabled() {
                // 3
                appLocationManager.requestLocation()
                appLocationManager.startUpdatingLocation()
            } else {
                // 5
                appLocationManager.requestAlwaysAuthorization()
            }
        }
        
    }
    
    private func setupGoogleMap(){
        
        //Setup core location
//        appLocationManager.delegate = self
        // 2
        
        setupLocationManager()
        
        guard mapView == nil else { return }
        
//        let options = GMSMapViewOptions()
        var marker: GMSMarker?
        var cameraPos: GMSCameraPosition = GMSCameraPosition()
        
        
        //31.4732206,74.2695823     //Johar town lat long
//        if let startPoint = viewModel.startPickUpLocationInfo?.coordinates{
//            let lat = startPoint.latitude
//        let long = startPoint.longitude
//            options.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
//        }
//        else{
            if let myLocation = appLocationManager.location?.coordinate{
                cameraPos = GMSCameraPosition(latitude: myLocation.latitude, longitude: myLocation.longitude, zoom: 15)
//                options.camera = cameraPos
            }
        else {
            cameraPos = GMSCameraPosition(latitude: 51.5072, longitude: 0.1276, zoom: 15)
        }
//        }
        
//        if let endPoint = viewModel.endDropOffLocationInfo?.coordinates {
//            //Setup end marker
//            marker = GMSMarker(position: endPoint)
//            marker?.iconView = CustomMarker.fromNib()
//        }
//
//        if let start = viewModel.startPickUpLocationInfo?.coordinates {
//            //Setup end marker
//            marker = GMSMarker(position: start)
//            let markerIcon = CustomMarker.fromNib()
//            markerIcon.markerImage.image = .start_location_point_icon
//            marker?.iconView = markerIcon
//        }
        
//        DispatchQueue.main.async {
//            options.frame = self.googleMapView.bounds
//        }
        
//        let mapViewInit = GMSMapView(options: options)
        
        //Old
        
        
        DispatchQueue.main.async {
            
            let options = GMSMapViewOptions()
            options.camera = cameraPos
            options.frame = self.googleMapView.bounds
            
            let mapViewInit = GMSMapView(options: options)
            mapViewInit.delegate = self
            mapViewInit.isMyLocationEnabled = false
            mapViewInit.settings.myLocationButton = false
            
            //For dark mode etc (disabled for now)
            /*
             switch appMapSettings.mapStyle.mapType {
                 
             case .defaultType:
                 mapViewInit.mapType = .normal
             case .terrain:
                 mapViewInit.mapType = .terrain
             case .satellite:
                 mapViewInit.mapType = .satellite
             }
             mapViewInit.isTrafficEnabled = appMapSettings.enableTraffic
             
             
             self.setMapTheme(map: mapViewInit)
             */
            
            self.mapView = mapViewInit
        }
        
        DispatchQueue.main.async {
            marker?.map = self.mapView
        }
        
        DispatchQueue.main.async {
            self.googleMapView.addSubview(self.mapView!)
        }
         
//        let distance = viewModel.getDistance()
//        distanceLbl.text = "\(String(format: "%.2f", (distance.0 ?? 0))) \(distance.1)"
        
    }
    
    private func addMarkers() {
        
        var marker: GMSMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1276))
        
        if let myLocation = appLocationManager.location?.coordinate {
            marker.position = myLocation
        }
        
        let customIcon = CustomMarker.fromNib()
        marker.iconView = customIcon
        marker.map = mapView
        
    }
    
    private func shouldShowNavBar(show: Bool) {
        if show {
            if navigationController?.isNavigationBarHidden == true {
                appNavigationCoordinator.shouldShowNavController(show: show, animted: false)
            }
        }
        else {
            if navigationController?.isNavigationBarHidden == false {
                appNavigationCoordinator.shouldShowNavController(show: show, animted: false)
            }
        }
        
    }
    
    @objc
    private func filterEventsScreen(){
        let vc = AppUIViewControllers.filterEventsScreen()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc
    private func showSideMenuScreen(){
        guard let sideMenuVc else { return }
        present(sideMenuVc, animated: true)
    }
    
    //MARK: ButtonActions
    @IBAction func addBtn(_ sender: Any) {
        let vc = AppUIViewControllers.addEventScreen()
//        let vc = AppUIViewControllers.signInScreen()
//        let vc = AppUIViewControllers.eventDetailScreen()
        appNavigationCoordinator.pushUIKit(vc)
    }
    
    
}

extension MainMapScreen: CLLocationManagerDelegate{
    
    func locationManager( _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
//        appLocationManager.requestLocation()
        
        //5
//        mapView?.isMyLocationEnabled = true
//        mapView?.settings.myLocationButton = true
    }
    
    // 6
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
//        viewModel.checkIfNearFuelStation(currentLat: location.coordinate.latitude, currentLong: location.coordinate.longitude)
        
        
        // 7
        /*
         mapView?.camera = GMSCameraPosition(
             target: location.coordinate,
             zoom: 15,
             bearing: 0,
             viewingAngle: 0)
         */
        
    }
    
    // 8
    func locationManager( _ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension MainMapScreen: GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //For future implementation
        /*
         viewModel.getLocationInfo(location: mapView.myLocation) { currentLocation, subLocation in
             print("Current location: \(currentLocation)")
         }
         */
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let vc = AppUIViewControllers.eventDetailScreen()
        appNavigationCoordinator.pushUIKit(vc)
        
        return true
    }
    
}

extension MainMapScreen {
    
    private func bindViewModel() {
        
    }
    
}
