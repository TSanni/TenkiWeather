//
//  CoreLocationViewModel.swift
//  Weather
//
//  Created by Tomas Sanni on 6/21/23.
//

import Foundation
import CoreLocation

protocol CoreLocationViewModelProtocol {
    var latitude: CLLocationDegrees { get }
    var longitude: CLLocationDegrees { get }
    var timezoneIdentifier: String { get }
    var timezoneSecondsFromGMT: Int { get }
    var localLocationName: String { get }
    var searchedLocationName: String { get set }

    func getLocalLocationName() async throws
    func getSearchedLocationName(lat: CLLocationDegrees, lon: CLLocationDegrees, name: String?) async throws
    func getPlaceDataFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> CLPlacemark?
}

class CoreLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, CoreLocationViewModelProtocol {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus?
    @Published private(set) var timezoneIdentifier: String = K.defaultTimezoneIdentifier
    @Published private(set) var timezoneSecondsFromGMT: Int = 0
    @Published private(set) var localLocationName: String = ""
    @Published var searchedLocationName: String = ""

    private var locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()

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

    // MARK: - Authorization Handling

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("Authorization status changed: \(status.rawValue)")

        DispatchQueue.main.async {
            self.authorizationStatus = status

            switch status {
            case .authorizedWhenInUse:
                self.locationManager.requestLocation()
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            default:
                break
            }
        }
    }

    // MARK: - Location Updates

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations called")
        if locations.last != nil {
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    // MARK: - Reverse Geocoding

    func getLocalLocationName() async throws {
        let name = try await getNameFromCoordinates(latitude: latitude, longitude: longitude)
        await MainActor.run { self.localLocationName = name }
    }

    func getSearchedLocationName(lat: CLLocationDegrees, lon: CLLocationDegrees, name: String?) async throws {
        let searched = try await getNameFromCoordinates(latitude: lat, longitude: lon, name: name)
        await MainActor.run { self.searchedLocationName = searched }
    }

    private func getNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String? = nil) async throws -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { [weak self] places, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let place = places?.first {
                    let result = self?.processPlacemark(place, fallbackName: name)
                    continuation.resume(returning: result ?? "")
                } else {
                    continuation.resume(throwing: NSError(domain: "Geocoder", code: 0, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"]))
                }
            }
        }
    }

    func getPlaceDataFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> CLPlacemark? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        do {
            return try await geocoder.reverseGeocodeLocation(location).first
        } catch {
            print("Geocoder error: \(error)")
            return nil
        }
    }

    // MARK: - Placemark Processing

    private func processPlacemark(_ place: CLPlacemark, fallbackName: String?) -> String {
        updateTimezone(from: place)

        if let name = fallbackName, Int(name) == nil {
            DispatchQueue.main.async {
                self.searchedLocationName = name
            }
            return name
        }

        return formatLocationName(city: place.locality, state: place.administrativeArea, country: place.country)
    }

    private func updateTimezone(from place: CLPlacemark) {
        DispatchQueue.main.async {
            self.timezoneIdentifier = place.timeZone?.identifier ?? K.defaultTimezoneIdentifier
            self.timezoneSecondsFromGMT = place.timeZone?.secondsFromGMT() ?? 0
        }
    }

    // MARK: - Formatting

    private func formatLocationName(city: String?, state: String?, country: String?) -> String {
        var parts: [String] = []

        if let city = city, let state = state, city == state || city.contains(state) {
            parts.append(city)
        } else {
            if let city = city { parts.append(city) }
            if let state = state { parts.append(state) }
        }

        if let country = country {
            parts.append(country)
        }

        return parts.joined(separator: ", ")
    }
}
