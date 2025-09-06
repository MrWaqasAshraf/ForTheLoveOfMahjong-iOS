//
//  SelectEventLocationScreen.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 06/09/2025.
//

import UIKit
import GoogleMaps

class SelectEventLocationScreen: UIViewController {
    
    static let identifier = "SelectEventLocationScreen"
    
    @IBOutlet weak var googleMapView: UIView!
    
    //Google maps
    private var mapView: GMSMapView?
    
    var closure: (( _ locationInfo: LocationComponents?, _ fullAddress: String?, _ coordinates: CLLocationCoordinate2D?)->())? = nil
    
//    private var viewModel: SignInViewModel
//    
//    init?(coder: NSCoder, viewModel: SignInViewModel) {
//        self.viewModel = viewModel
//        super.init(coder: coder)
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUiElements()
        setupGoogleMap()
    }
    
    private func setupUiElements() {
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn])]))
        
    }
    
    @objc
    private func goBack() {
        appNavigationCoordinator.pop()
    }
    
    
    private func setupGoogleMap(){
        
        //Setup core location
//        appLocationManager.delegate = self
        // 2
        
//        setupLocationManager()
        
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
            }
        else {
            cameraPos = GMSCameraPosition(latitude: 51.5072, longitude: 0.1276, zoom: 15)
        }
        
        
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
        
    }
    
    //MARK: ButtonActions
    @IBAction func addBtn(_ sender: Any) {
        guard let mapView else { return }
        var coordinates = mapView.camera.target
        
        DispatchQueue.main.async {
            ActivityIndicator.shared.showActivityIndicator(view: self.view)
        }
        
        locationService.getLocationInfo(location: coordinates.toCLLocation, requetedLocationType: .all) { [weak self] fullAdd, _, allComponents  in
            
            DispatchQueue.main.async {
                ActivityIndicator.shared.removeActivityIndicator()
            }
            
            if let closure = self?.closure {
                closure(allComponents, fullAdd, coordinates)
            }
            
            DispatchQueue.main.async {
                self?.goBack()
            }
            
        }
    }
    
}

extension SelectEventLocationScreen: GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //For future implementation
        /*
         viewModel.getLocationInfo(location: mapView.myLocation) { currentLocation, subLocation in
             print("Current location: \(currentLocation)")
         }
         */
        
    }
    
}

extension SelectEventLocationScreen {
    
    private func bindViewModel() {
        
        
        
    }
    
}
