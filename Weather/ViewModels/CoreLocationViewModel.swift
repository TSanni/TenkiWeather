//
//  CoreLocationViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/21/23.
//

import Foundation
import CoreLocation




enum GeocodingErrors: Error {
    case reverseGeocodingError
    case goecodingError
}

class CoreLocationViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var publishedError: GeocodingErrors?
    @Published var currentLocationName: String = ""
    @Published var timezoneForCoordinateInput: Int = 0
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
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
    
    //MARK: - Location
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus.rawValue)
        print("locationManagerDidChangeAuthorization delegate called ")
        
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
                
            case .notDetermined:  // Authorization not determined yet.
                authorizationStatus = .notDetermined
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations delegate called ")
        // Insert code to handle location updates
        if locations.last != nil {
            manager.stopUpdatingLocation()
            print("Latitude: \(latitude) and longitude: \(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error from didFailWithError delegate method: \(error.localizedDescription)")
    }
    
    
    
    //MARK: - Geocoding
    
    ///Will get all names for pass in coordinates
    func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(coordinates) { [weak self] places, error in
                
                if let places = places {

                    let cityName = places[0].locality
                    let state = places[0].administrativeArea
                    let country = places[0].country
                    
                    let timezone = places[0].timeZone?.secondsFromGMT()
                    
                    self?.timezoneForCoordinateInput = timezone ?? 0
                    

                    
                    
                    ///Going through possible combinations of optionals existing
                    if let cityName = cityName, let state = state, let country = country { // All optionals exist
                        if cityName == state {
                            self?.currentLocationName = "\(cityName), \(country)"
                        } else {
                            self?.currentLocationName = "\(cityName), \(state), \(country)"
                        }
                    } else if let state = state, let country = country { // Only state and country exist
                        self?.currentLocationName = "\(state), \(country)"
                    } else if let cityName = cityName, let country = country { // Only city and country exist
                        self?.currentLocationName = "\(cityName), \(country)"
                    } else if let cityName = cityName { // Only city exists
                        self?.currentLocationName = "\(cityName)"
                    } else if let state = state { // Only state exists
                        self?.currentLocationName = "\(state)"
                    } else if let country = country { // Only country exists
                        self?.currentLocationName = "\(country)"
                    }

                    continuation.resume()
                    
                } else if let error = error {
                    self?.publishedError = .reverseGeocodingError
                    continuation.resume(throwing: error)
                }
            }
        }
        
    }
    
    func getCoordinatesFromName(name: String) async throws -> CLLocation {
        
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(name) { [weak self] places, error in
                
                if let places = places {

                    let cityName = places[0].locality
                    let timezone = places[0].timeZone?.secondsFromGMT()
                    
                    self?.timezoneForCoordinateInput = timezone ?? 0
                    
                    
                    let state = places[0].administrativeArea
                    let country = places[0].country
                    
                    
                    let coordinates = places[0].location
                        
                    ///Going through possible combinations of optionals existing
                    if let cityName = cityName, let state = state, let country = country { // All optionals exist
                        if cityName == state {
                            self?.currentLocationName = "\(cityName), \(country)"
                        } else {
                            self?.currentLocationName = "\(cityName), \(state), \(country)"
                        }
                    } else if let state = state, let country = country { // Only state and country exist
                        self?.currentLocationName = "\(state), \(country)"
                    } else if let cityName = cityName, let country = country { // Only city and country exist
                        self?.currentLocationName = "\(cityName), \(country)"
                    } else if let cityName = cityName { // Only city exists
                        self?.currentLocationName = "\(cityName)"
                    } else if let state = state { // Only state exists
                        self?.currentLocationName = "\(state)"
                    } else if let country = country { // Only country exists
                        self?.currentLocationName = "\(country)"
                    }
                        
                        
                    
                    continuation.resume(returning: coordinates ?? CLLocation(latitude: 0, longitude: 0))
                        
                } else if let error = error {
                    self?.publishedError = .goecodingError
                    continuation.resume(throwing: error)
                }
                
            }
        }
        
    }
    
}
