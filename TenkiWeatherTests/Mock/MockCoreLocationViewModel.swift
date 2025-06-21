//
//  MockCoreLocationViewModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 6/13/25.
//

import Foundation
import CoreLocation

class MockCoreLocationViewModel: CoreLocationViewModelProtocol {

    var latitude: CLLocationDegrees = 29.7603761
    var longitude: CLLocationDegrees = -95.3698054
    var timezoneIdentifier: String = "America/Chicago"
    var timezoneSecondsFromGMT: Int = -18000
    var localLocationName: String = "Houston, TX, United States"
    var searchedLocationName: String = "Houston, TX, United States"

    func getLocalLocationName() async throws {
        // Simulate setting a name
        let name = "Houston, TX, United States"
        localLocationName = name
    }

    func getSearchedLocationName(lat: CLLocationDegrees, lon: CLLocationDegrees, name: String?) async throws {
        let searched = "New York"
        searchedLocationName = searched
    }
    
    func getPlaceDataFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> CLPlacemark? {
        nil
    }
}
