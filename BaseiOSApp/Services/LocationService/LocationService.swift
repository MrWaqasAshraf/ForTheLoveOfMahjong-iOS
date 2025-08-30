//
//  LocationService.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import CoreLocation
import UIKit

let appLocationManager: CLLocationManager = CLLocationManager()

struct LocationComponents {
    var city: String?
    var state: String?
    var country: String?
}

struct LocationDidUpdateLocationsModel {
    /*
     static let didUpdateLocations: Notification.Name = Notification.Name("didUpdateLocations")
     func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
     */
    var manager: CLLocationManager
    var locations: [CLLocation]
    
}

struct LocationDidUpdateHeadingModel {
    /*
     static let didUpdateHeading: Notification.Name = Notification.Name("didUpdateHeading")
     func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
     */
    var manager: CLLocationManager
    var newHeading: CLHeading
}

struct LocationDidChangeAuthorizationModel {
    /*
     static let didChangeAuthorization: Notification.Name = Notification.Name("didChangeAuthorization")
     func locationManager( _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
     */
    var manager: CLLocationManager
    var status: CLAuthorizationStatus
}

struct LocationDidFailWithErrorModel {
    /*
     static let didFailWithError: Notification.Name = Notification.Name("didFailWithError")
     func locationManager( _ manager: CLLocationManager, didFailWithError error: Error)
     */
    var manager: CLLocationManager
    var error: Error
}

class AppLocationService{
    
    enum RequestedLocationType {
        case city
        case country
        case state
        case all
    }
    
    func getDistance(from: CLLocation?, to: CLLocation?) -> Double?{
        guard let from, let to else { return nil }
        let distanceInMeters: Double = Double(to.distance(from: from))
        return distanceInMeters
    }
    
    func getLocationInfo(location: CLLocation?, requetedLocationType: RequestedLocationType? = nil, completion: @escaping (String, String?, _ allLocationComponents: LocationComponents?) -> Void){
        var locationAddress: String = ""
        guard let location else {
            completion(locationAddress, nil, nil)
            return
        }
        var allLocationComps: LocationComponents = LocationComponents()
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?.first
            
            
            // Location name
            if let locationName = placeMark?.name {
                print(locationName)
                locationAddress += locationName
            }
            
            // Street address
            if let street = placeMark?.subThoroughfare {
                print(street)
                locationAddress += ", \(street)"
            }
            
            // City
            if let city = placeMark?.locality {
                print(city)
                locationAddress += ", \(city)"
                if let requetedLocationType {
                    
                    if requetedLocationType == .city {
                        completion(locationAddress, city, LocationComponents(city: city))
                        return
                    }
                    else {
                        allLocationComps.city = city
                    }
                }
            }
            
            // City
            if let subLocality = placeMark?.subLocality {
                print(subLocality)
                locationAddress += ", \(subLocality)"
            }
            
            //State
            if let state = placeMark?.administrativeArea {
                print("state is: \(state)")
                if let requetedLocationType {
                    
                    if requetedLocationType == .state {
                        completion(locationAddress, state, LocationComponents(state: state))
                        return
                    }
                    else {
                        allLocationComps.state = state
                    }
                    
                }
            }
            
            // Zip code
            if let zip = placeMark?.postalCode {
                print(zip)
                locationAddress += ", \(zip)"
            }
            
            // Country
            if let country = placeMark?.country {
                print(country)
                locationAddress += ", \(country)"
                
                if let requetedLocationType {
                    
                    if requetedLocationType == .country {
                        completion(locationAddress, country, LocationComponents(country: country))
                        return
                    }
                    else {
                        allLocationComps.country = country
                    }
                    
                }
                
            }
            
            completion(locationAddress, nil, allLocationComps)
            
        })
    }
    
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> Double {

        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)

        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
}

//class LocationNetworkService: ServicesDelegate{
//    
//    func getMapRouteApi(startLat: String?, startLong: String?, endLat: String?, endLong: String?, completion: @escaping (Result<(MapDirectionResponse?, Int?), Error>) -> ()){
//        var params: [String] = []
//        params.append("key=\(GMapKey.apiKey.rawValue)")
//        params.append("mode=driving")
//        
//        //Temp
////        params.append("alternatives=true")
//        if let startLat, let startLong {
//            
//            //Original implementation
//            params.append("origin=\(startLat),\(startLong)")
//            
//            //For testing heading
////            params.append("origin=heading=90:\(startLat),\(startLong)")
//            
//        }
//        if let endLat, let endLong{
//            
//            //Original implementation
////            params.append("destination=\(endLat),\(endLong)")
//            
//            //For testing
//            params.append("destination=\(endLat),\(endLong)")
//            
//            
//        }
//        let queryParameters: String = QueryParamMaker.makeQueryParam(params: params)
//        let endPoint: String = EndPoint.googleDirectionsApi.rawValue + queryParameters
//        getResponse(.post, ignoreBaseUrl: true, endPoint: endPoint, parameters: [:], completion: completion)
//    }
//    
//    func getResponse(useAlamofire: Bool = false, _ type: RequestType, ignoreBaseUrl: Bool, endPoint: String, parameters: [String : Any]? = nil, customHeaders: [String : String]? = nil, isMultiPartData: ParameterType? = nil, rawData: String? = nil, files: FileParameters? = nil, completion: @escaping (Result<(MapDirectionResponse?, Int?), Error>) -> ()) {
//        API.shared.api(useAlamofire: useAlamofire, type: type, ignoreBaseUrl: ignoreBaseUrl, endpoint: endPoint, parameters: parameters, customHeaders: customHeaders, isMultiPartData: isMultiPartData, rawData: rawData, files: files, expecting: MapDirectionResponse.self) { result in
//            switch result {
//            case .success((let data, let resp)):
//                print("\(endPoint) API status code: \(resp.statusCode), Data is: \(data)")
//                completion(.success((data, resp.statusCode)))
//            case .failure(let error):
//                print(error.localizedDescription)
//                completion(.failure(error))
//            }
//        }
//    }
//    
//}

class DeviceLocationManager {
    
    func checkLocationPermission(completion: @escaping (LocationPermission) -> Void){
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                getAuthorizationStatusValue(status: appLocationManager.authorizationStatus, completion: completion)
            }
            else {
                getAuthorizationStatusValue(status: CLLocationManager.authorizationStatus(), completion: completion)
            }
            
        } else {
            print("Location services are not enabled")
            completion(.notDetermined)
        }
    }
    
    private func getAuthorizationStatusValue(status: CLAuthorizationStatus, completion: @escaping (LocationPermission) -> Void){
        switch status {
        case .notDetermined:
            print("notDetermined")
            completion(.notDetermined)
        case .restricted:
            print("restricted")
            completion(.restricted)
        case .denied:
            print("denied")
            completion(.denied)
        case .authorizedAlways:
            print("authorizedAlways")
            completion(.authorizedAlways)
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            completion(.authorizedWhenInUse)
        @unknown default:
            print("unKnown")
            completion(.unKnown)
            break
        }
    }
    
}

enum LocationPermission{
    
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case unKnown
    
}

