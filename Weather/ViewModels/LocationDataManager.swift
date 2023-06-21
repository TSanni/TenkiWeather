//
//  LocationDataManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/21/23.
//

import Foundation
import CoreLocation

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
//    @Published var latitude: CLLocationDegrees = 0
//    @Published var longitude: CLLocationDegrees = 0
    
    var locationManager = CLLocationManager()
    
    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
        if let location = locations.last {
            manager.stopUpdatingLocation()
//            latitude = location.coordinate.latitude
//            longitude = location.coordinate.longitude
            print("Latitude: \(latitude) and longitude: \(longitude)")
            //getWeatherWithCoordinates(latitude: lat, longitude: lon)
            
            //MARK : Will work with this later
//            let location = CLLocation(latitude:lat, longitude: lon)
//            location.fetchCityAndCountry { city, country, error in
//                guard let city = city, let country = country, error == nil else { return }
//                print(city + ", " + country)  // Rio de Janeiro, Brazil
//                self.userLocation = city + ", " + country
//            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
}
