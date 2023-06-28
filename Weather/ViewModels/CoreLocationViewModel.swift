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
//                getNameFromCoordinates(latitude: latitude, longitude: longitude)
                
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
    func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(coordinates) { [weak self] places, error in
                if error != nil {
                    self?.publishedError = .reverseGeocodingError
                    continuation.resume()
                }
                
                if let locations = places {
                    // print("CLPlacemark returned is: \(locations[0]) ")
                    // let name = locations[0].name
                    
                    
                    let cityName = locations[0].locality
                    let timezone = locations[0].timeZone?.secondsFromGMT()
                    
                    self?.timezoneForCoordinateInput = timezone ?? 0
                    
                    let state = locations[0].administrativeArea
                    let country = locations[0].country
                    
                    if cityName == state {
                        self?.currentLocationName = "\(cityName ?? ""), \(country ?? "")"
                    } else {
                        self?.currentLocationName = "\(cityName ?? ""), \(state ?? ""), \(country ?? "")"
                    }
                    continuation.resume()
                } else {
                    continuation.resume()
                    fatalError("Unable to get location. Check getNameFromCoordinates function")
                }

            }
        }

    }
    
    func getCoordinatesFromName(name: String) async throws -> CLLocation {
        
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(name) { [weak self] places, error in
                if let error = error {
                    self?.publishedError = .goecodingError
                    continuation.resume(throwing: error)
                }
                
                if let locations = places {
//                    let name = locations[0].name
                    
                    
                    let cityName = locations[0].locality
                    let timezone = locations[0].timeZone?.secondsFromGMT()
                    
                    self?.timezoneForCoordinateInput = timezone ?? 0

                    
                    let state = locations[0].administrativeArea
                    let country = locations[0].country
                    
//                    self?.searchedLocationName = "\(cityName ?? ""), \(state ?? "")"
                    
                    if let coordinates = locations[0].location {

                        
                        if cityName == state {
                            self?.currentLocationName = "\(cityName ?? ""), \(country ?? "")"

                        } else {
                            self?.currentLocationName = "\(cityName ?? ""), \(state ?? ""), \(country ?? "")"
                        }
                        

                        continuation.resume(returning: coordinates)
                    } else {
                        print("UNABLE TO GET COORDINATES: CHECK getCoordinatesFromName function")
                    }
                    
                }
            }
        }
  
    }

}
