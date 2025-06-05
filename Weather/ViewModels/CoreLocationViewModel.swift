//
//  CoreLocationViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/21/23.
//

import Foundation
import CoreLocation


class CoreLocationViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var timezoneIdentifier: String = K.defaultTimezoneIdentifier
    @Published private(set) var timezoneSecondsFromGMT: Int = 0
    @Published private(set) var localLocationName: String = ""
    @Published var searchedLocationName: String = ""
    
    var locationManager = CLLocationManager()
    
    var geocoder = CLGeocoder()
    
    var latitude: CLLocationDegrees {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    
    var longitude: CLLocationDegrees {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
    override init() {
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
  
    func getLocalLocationName() async throws {
        do {
            let location = try await getNameFromCoordinates(latitude: latitude, longitude: longitude)
            await MainActor.run {
                self.localLocationName = location
            }
        } catch {
            throw error
        }
        
        
    }
    
    func getSearchedLocationName(lat: CLLocationDegrees, lon: CLLocationDegrees, name: String?) async throws {
        
        do {
            let searched = try await getNameFromCoordinates(latitude: lat, longitude: lon, name: name)
            await MainActor.run {
                self.searchedLocationName = searched
            }
        } catch {
            throw error
        }
        


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
    
    
    //TODO: Update this function. A lot of unneeded code. Most likely can delete combinationOfNames method.
    private func getLocationName(place: CLPlacemark, name: String? = nil) -> String {
        
        let cityName = place.locality
        let state = place.administrativeArea
        let country = place.country
        let timezoneIdentifier = place.timeZone?.identifier ?? K.defaultTimezoneIdentifier
        let secondsFromGMT = place.timeZone?.secondsFromGMT() ?? 0
        DispatchQueue.main.async {
            self.timezoneIdentifier = timezoneIdentifier
            self.timezoneSecondsFromGMT = secondsFromGMT
        }

        if let name = name {
            if Int(name) == nil { /// user submits name, not zipcode
                DispatchQueue.main.async {
                    self.searchedLocationName = "\(name)"
                }
                return "\(name)"
            } else {
                return combinationOfNames(cityName: cityName, state: state, country: country)
            }
        } else {
            return combinationOfNames(cityName: cityName, state: state, country: country)
        }
    }
    
    //MARK: - Geocoding
    ///Will get all names for pass in coordinates
//    private func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String? = nil) async -> String {
//        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
//        return await withCheckedContinuation { continuation in
//            geocoder.reverseGeocodeLocation(coordinates) { [weak self] places, error in
//                
//                if let place = places?.first {
//                    let locationName = self?.getLocationName(place: place, name: name)
//                    continuation.resume(returning: locationName ?? "")
//                } else {
//                    continuation.resume(returning: "")
//                }
//            }
//        }
//        
//    }
    
    private func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String? = nil) async throws -> String {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(coordinates) { [weak self] places, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let place = places?.first {
                    let locationName = self?.getLocationName(place: place, name: name)
                    continuation.resume(returning: locationName ?? "")
                } else {
                    continuation.resume(throwing: NSError(domain: "Geocoder", code: 0, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"]))
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
