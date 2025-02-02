//
//  LocationSearchViewModel.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 1/28/25.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var query: String = "" {
        didSet {
            // Update the query fragment for autocomplete
            searchCompleter.queryFragment = query
        }
    }
    @Published var suggestions: [MKLocalSearchCompletion] = []

    private var searchCompleter: MKLocalSearchCompleter

    override init() {
        self.searchCompleter = MKLocalSearchCompleter()
        super.init()
        self.searchCompleter.delegate = self

        // Configure to only return address-related results
        searchCompleter.resultTypes = .address
    }

    // MARK: - MKLocalSearchCompleterDelegate Methods
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Update suggestions based on search results
        self.suggestions = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Autocomplete Error: \(error.localizedDescription)")
    }

    // MARK: - Fetch City-Like Locations
    func fetchCityLocation(for completion: MKLocalSearchCompletion, completionHandler: @escaping (CLLocationCoordinate2D?, String?, Error?) -> Void) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)

        search.start { response, error in
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }

            // Process the first result, filtering for city-like locations
            if let mapItem = response?.mapItems.first {
                let placemark = mapItem.placemark

                // Check if the placemark is a city, town, or administrative area
                if placemark.locality != nil || placemark.administrativeArea != nil || placemark.country != nil {
                    
                    let coordinate = placemark.coordinate
                    let locationName = mapItem.placemark.title
                    
                    print("locationName: \(locationName)")
                    completionHandler(coordinate, locationName, nil)
                } else {
                    completionHandler(nil, nil, NSError(domain: "InvalidLocation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Not a city-like location"]))
                }
            } else {
                completionHandler(nil, nil, NSError(domain: "NoResults", code: 404, userInfo: [NSLocalizedDescriptionKey: "No locations found"]))
            }
        }
    }
}
