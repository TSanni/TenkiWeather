//
//  CoreLocationViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/21/23.
//

import Foundation
import CoreLocation

//TODO: Remove publishedError property

class CoreLocationViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var timezoneForCoordinateInput: Int = 0
    @Published private(set) var localLocationName: String = ""
    @Published var searchedLocationName: String = ""

    static let shared = CoreLocationViewModel()
    
    var locationManager = CLLocationManager()
    
    var geocoder = CLGeocoder()
    
    var latitude: CLLocationDegrees {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    
    var longitude: CLLocationDegrees {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
    override private init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - Location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Location manager authorization status raw value: \(manager.authorizationStatus.rawValue)" )
        
        DispatchQueue.main.async {
            switch manager.authorizationStatus {
                case .authorizedWhenInUse:  // Location services are available.
                    // Insert code here of what should happen when Location services are authorized
                self.authorizationStatus = .authorizedWhenInUse
                self.locationManager.requestLocation()
                    break
                    
                case .restricted:  // Location services currently unavailable.
                    // Insert code here of what should happen when Location services are NOT authorized
                self.authorizationStatus = .restricted
                    break
                    
                case .denied:  // Location services currently unavailable.
                    // Insert code here of what should happen when Location services are NOT authorized
                self.authorizationStatus = .denied
                    break
                    
                case .notDetermined:  // Authorization not determined yet.
                self.authorizationStatus = .notDetermined
                    manager.requestWhenInUseAuthorization()
                    break
                    
                default:
                    break
            }

        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations delegate called ")
        // Insert code to handle location updates
        if locations.last != nil {
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error from didFailWithError delegate method: \(error.localizedDescription)")
    }
  
    func getLocalLocationName() async {
        let location = await getNameFromCoordinates(latitude: latitude, longitude: longitude)
        
        await MainActor.run(body: {
            self.localLocationName = location
        })
    }
    
    func getSearchedLocationName(lat: CLLocationDegrees, lon: CLLocationDegrees, nameFromGoogle: String?) async {
        
        let searched = await getNameFromCoordinates(latitude: lat, longitude: lon, nameFromGoogleAPI: nameFromGoogle)
        
        await MainActor.run(body: {
            self.searchedLocationName = searched
        })
    }
    
    private func combinationOfNames(cityName: String?, state: String?, country: String?) -> String {
        /// Going through possible combinations of optionals existing
        if let cityName = cityName, let state = state, let country = country { // All optionals exist
            if cityName == state || cityName.contains(state) {
                return "\(cityName), \(country)"
            } else {
                return "\(cityName), \(state), \(country)"
            }
        } else if let state = state, let country = country { // Only state and country exist
            return "\(state), \(country)"
        } else if let cityName = cityName, let country = country { // Only city and country exist
            return "\(cityName), \(country)"
        } else if let cityName = cityName { // Only city exists
            return "\(cityName)"
        } else if let state = state { // Only state exists
            return "\(state)"
        } else if let country = country { // Only country exists
            return "\(country)"
        } else {
            return ""
        }
        
    }
    
    private func getLocationName(place: CLPlacemark, placeFromGoogle: String? = nil) -> String {
        
        let cityName = place.locality
        let state = place.administrativeArea
        let country = place.country
        let timezone = place.timeZone?.secondsFromGMT()
        
        DispatchQueue.main.async {
            self.timezoneForCoordinateInput = timezone ?? 0
        }

        if let placeFromGoogle = placeFromGoogle {
            if Int(placeFromGoogle) == nil { /// user submits name, not zipcode
                DispatchQueue.main.async {
                    self.searchedLocationName = "\(placeFromGoogle), \(country ?? "")"
                }
                return "\(placeFromGoogle), \(country ?? "")"
            } else {
                return combinationOfNames(cityName: cityName, state: state, country: country)
            }
        } else {
            return combinationOfNames(cityName: cityName, state: state, country: country)
        }
    }
    
    //MARK: - Geocoding
    ///Will get all names for pass in coordinates
    private func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, nameFromGoogleAPI: String? = nil) async -> String {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(coordinates) { [weak self] places, error in
                
                if let place = places?.first {
                    let locationName = self?.getLocationName(place: place, placeFromGoogle: nameFromGoogleAPI)
                    continuation.resume(returning: locationName ?? "")
                } else {
                    continuation.resume(returning: "")
                }
            }
        }
        
    }
    
    func getPlaceDataFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> CLPlacemark? {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placesArray = try await geocoder.reverseGeocodeLocation(coordinates)
            if let firstPlace = placesArray.first {
                return firstPlace
            }
        } catch {
            print(error)
        }
        
        return nil
    }
 
}
