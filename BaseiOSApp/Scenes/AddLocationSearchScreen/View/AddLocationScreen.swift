//
//  AddLocationScreen.swift
//  rebox
//
//  Created by Waqas Ashraf on 14/03/2024.
//

import UIKit
import MapKit

class AddLocationScreen: UIViewController{
    
    static let identifier = "AddLocationScreen"
    
    @IBOutlet weak var navigationBar: UIStackView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var locationSearchField: UITextField!
    
    private var mapSearchWorkItem: DispatchWorkItem?
    private var queue: DispatchQueue = DispatchQueue(label: "map-search-queue")
    
    private var locations = [LocationModel]()
    
    var closure: ((LocationModel)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUiElements()
    }
    
    private func setupUiElements(){
        
        //Add custom nav bar
//        CustomNavigationBar.addNavBar(parentView: navigationBar, title: "Add Location".localizeString(originalText: "Add Location"), titleAlignment: .center, image: .close_icon, leadImageTintColor: .black) { [weak self] btnIndex, navBar in
//            if btnIndex == 0{
//                self?.goBack()
//            }
//        }
        
        
        let img = UIImage.arrowLeft.withRenderingMode(.alwaysTemplate)
        let barBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(goBack))
        barBtn.tintColor = .black
        
        let titleLbl = ReusableLabelUI.fromNib()
        titleLbl.titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.titleLbl.text =  "Add Location"
        titleLbl.titleLbl.textColor = .black
        
        createSystemNavBar(systemNavBarSetup: .init(hideSystemBackButton: true, buttonsSetup: [.init(position: .left, barButtons: [barBtn]),  .init(position: .center, customView: titleLbl)]))
        
        registerCell()
        
    }
    
    @objc
    private func goBack(){
        appNavigationCoordinator.pop()
    }
    
    private func registerCell(){
        let cellNib = UINib(nibName: LocationInfoCell.identifier, bundle: .main)
        searchTableView.register(cellNib, forCellReuseIdentifier: LocationInfoCell.identifier)
    }
    
    private func getLocationInfo(location: CLLocation?, completion: @escaping (String) -> Void){
        var locationAddress: String = ""
        guard let location else {
            completion(locationAddress)
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?.first
            
            
            // Location name
            if let locationName = placeMark.name {
                print(locationName)
                locationAddress += locationName
            }
            
            // Street address
            if let street = placeMark.subThoroughfare {
                print(street)
                locationAddress += ", \(street)"
            }
            
            // City
            if let city = placeMark.locality {
                print(city)
                locationAddress += ", \(city)"
            }
            
            // City
            if let subLocality = placeMark.subLocality {
                print(subLocality)
                locationAddress += ", \(subLocality)"
            }
            
            // Zip code
            if let zip = placeMark.postalCode {
                print(zip)
                locationAddress += ", \(zip)"
            }
            
            // Country
            if let country = placeMark.country {
                print(country)
                locationAddress += ", \(country)"
            }
            
            completion(locationAddress)
            
        })
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        performSearchRequest(searchText: sender.text)
    }
    
    @IBAction func useCurrentLocationBtn(_ sender: Any) {
        if let currentLocation = appLocationManager.location?.coordinate{
            getLocationInfo(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) { [weak self] locationAddress in
                let location: LocationModel = LocationModel(locationName: "Current location", location: locationAddress, coordinates: currentLocation)
                if let closure = self?.closure{
                    closure(location)
                }
                print("User's coordinates are: \(currentLocation)")
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            GenericToast.showToast(message: "Couldn't fetch current location, check your location permissions")
        }
    }
    
}

extension AddLocationScreen{
    
    private func performSearchRequest(searchText: String?) {
        
        print("Search text: \(String(describing: searchText))")
        
        mapSearchWorkItem?.cancel()
        let workItem: DispatchWorkItem = DispatchWorkItem {
            self.mapSearch(searchText: searchText)
        }
        mapSearchWorkItem = workItem
        queue.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
    }
    
    private func mapSearch(searchText: String?){
        
        locations = []
        
        let request = MKLocalSearch.Request()
       
        //Dummy regions
        //lat: "31.4205", long: "74.210"
        let regionCordinates = CLLocationCoordinate2D(latitude: 31.4205, longitude: 74.210)
        
        request.naturalLanguageQuery = "\(searchText ?? "")"
        
        //Actual region according to user's location
//        guard let coordinate = locationManager.location?.coordinate else { return }
//        request.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3200, longitudinalMeters: 3200)
        
        request.region = MKCoordinateRegion(center: regionCordinates, latitudinalMeters: 3200, longitudinalMeters: 3200)
        // about a couple miles around you
        
        MKLocalSearch(request: request).start { [weak self] (response, error) in
            
            print("Search response: \(String(describing: response))")
            
            if let error{
                print("Search error: \(error.localizedDescription)")
            }
            else{
                guard let response = response else { return }
                guard response.mapItems.count > 0 else { return }
                let randomIndex = Int(arc4random_uniform(UInt32(response.mapItems.count)))
                let locationItems = response.mapItems[randomIndex]
                
                for location in response.mapItems {
                    let location = LocationModel(locationName: location.name ?? "", location: "\(location.placemark.subLocality ?? "") \(location.placemark.locality ?? "")", coordinates: location.placemark.coordinate)
                    self?.locations.append(location)
                }
                
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
                
            }
        }
    }
    
}

extension AddLocationScreen: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: LocationInfoCell.identifier, for: indexPath) as! LocationInfoCell
        let data = locations[indexPath.row]
        cell.configureLocationCell(locationName: data.locationName, location: data.location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = locations[indexPath.row]
        print("Coordinates: \(String(describing: data.coordinates))")
        tableView.deselectRow(at: indexPath, animated: true)
        if let closure{
            closure(data)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
}

class LocationModel: NSObject {
    var locationName: String!
    var location: String!
    var coordinates: CLLocationCoordinate2D?

    init(locationName: String, location: String, coordinates: CLLocationCoordinate2D? = nil) {
        self.locationName = locationName
        self.location = location
        self.coordinates = coordinates
    }
}
