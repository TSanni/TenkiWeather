//
//  GeocodingManager.swift
//  Weather
//
//  Created by Tomas Sanni on 6/23/23.
//

import Foundation

//struct GeocodeData: Codable {
//    let name: String
//    let lat: Double
//    let lon: Double
//    let country: String
//    let state: String?
//}

//class GeocodingManager {
//    private let apiKey = K.apiKey
//    private let directGeocodeAPI = "https://api.openweathermap.org/geo/1.0/direct?"
//    private let revereseGeocodeAPI = "https://api.openweathermap.org/geo/1.0/reverse?"
//    static let shared = GeocodingManager()
//
//    func performGeocodeRequest(with cityName: String) async -> GeocodeData? {
//        guard let apiKey = apiKey else { fatalError("Could not get apikey for geocoding") }
//        guard let geocodeURL = URL(string: "\(directGeocodeAPI)q=\(cityName)&appid=\(apiKey)") else { return nil }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: geocodeURL)
//            let decodedData = try JSONDecoder().decode([GeocodeData].self, from: data)
//
//            let returnedData = GeocodeData(
//                name: decodedData[0].name,
//                lat: decodedData[0].lat,
//                lon: decodedData[0].lon,
//                country: decodedData[0].country,
//                state: decodedData[0].state
//            )
//
//            return returnedData
//
//        } catch {
//            print("ERROR GETTING DATA FROM GEO URL")
//        }
//
//        return nil
//    }
//
//
//    func performRevereseGeocoding(lat: Double, lon: Double) async -> GeocodeData? {
//        guard let apiKey = apiKey else { fatalError("Could not get apikey for reverse geocoding") }
//        guard let reverseGeocodeURL = URL(string: "\(revereseGeocodeAPI)lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else { return nil }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: reverseGeocodeURL)
//            print("WORKED")
//            let decodedData = try JSONDecoder().decode([GeocodeData].self, from: data)
//
//            let returnedData = GeocodeData(
//                name: decodedData[0].name,
//                lat: decodedData[0].lat,
//                lon: decodedData[0].lon,
//                country: decodedData[0].country,
//                state: decodedData[0].state
//            )
//
//            return returnedData
//        } catch {
//            print("ERROR GETTING DATA FROM REVERSE GEO URL: \(error.localizedDescription)")
//
//        }
//
//        return nil
//    }
//
//
//}



//class GeocodingViewModel: ObservableObject {
//    @Published var searchLocation = ""
//    @Published var latitude: Double = 0
//    @Published var longitude: Double = 0
//    
//    @Published var currentLocation = ""
//
//    func getCurrentLocationGeoData(lat: Double, lon: Double) async {
//        if let successfulGeocode = await GeocodingManager.shared.performRevereseGeocoding(lat: lat, lon: lon) {
//            if let stateAvailable = successfulGeocode.state {
//                await MainActor.run {
//                    currentLocation = "\(successfulGeocode.name), \(stateAvailable)"
//                }
//            } else {
//                await MainActor.run {
//                    currentLocation = "\(successfulGeocode.name), \(successfulGeocode.country)"
//                }
//            }
//            
//            print("CURRENT: \(searchLocation)")
//        }
//    }
//    
//    
//    func getGeoData(name: String) async {
//        if let successfulGeocode = await GeocodingManager.shared.performGeocodeRequest(with: name) {
//            if let stateAvailable = successfulGeocode.state {
//                await MainActor.run {
//                    searchLocation = "\(successfulGeocode.name), \(stateAvailable)"
//                }
//            } else {
//                await MainActor.run {
//                    searchLocation = "\(successfulGeocode.name), \(successfulGeocode.country)"
//                }
//            }
//            await MainActor.run {
//                latitude = successfulGeocode.lat
//                longitude = successfulGeocode.lon
//            }
//         
//        }
//    }
//    
//    func getReverseGeoData(lat: Double, lon: Double) async {
//        if let successfulGeocode = await GeocodingManager.shared.performRevereseGeocoding(lat: lat, lon: lon) {
//            if let stateAvailable = successfulGeocode.state {
//                await MainActor.run {
//                    searchLocation = "\(successfulGeocode.name), \(stateAvailable)"
//                }
//            } else {
//                await MainActor.run {
//                    searchLocation = "\(successfulGeocode.name), \(successfulGeocode.country)"
//                }
//            }
//            
//            print("THE NAME: \(searchLocation)")
//        }
//    }
//    
//    
//    
//}


//func performGeocodeRequest(with cityName: String) {
//
//    guard let apiKey = apiKey else { fatalError("Could not get apikey")}
//
//    let geocodeURL = "\(directGeocodeAPI)q=\(cityName)&appid=\(apiKey)"
//
//
//    if let url = URL(string: geocodeURL) {
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: url) { data, response, error in
//
//            if let error = error {
//                print("Could not perform geocode: \(error)")
//                return
//            }
//
//            if let safeData = data {
//                let decoder = JSONDecoder()
//                do {
//                    let geocodeData = try decoder.decode([GeocodeData].self, from: safeData)
//
//                    if geocodeData.isEmpty {
//                        print("The geocode is empty")
//                        self.incorrectSearchAlert()
//                        return
//                        //make alert that tells user the name is invalid
//                    } else {
//                        print("The geoCode data is: \(geocodeData)")
//
//                        let geoCityName = geocodeData[0].name
//                        let geoCountryName = geocodeData[0].country
//                        let geoLat = geocodeData[0].lat
//                        let geoLon = geocodeData[0].lon
//
//                        print( geocodeData[0].name)
//                        print("Geo coordinates: Lat - \(geocodeData[0].lat) || lon - \(geocodeData[0].lon)")
//                        self.getWeatherWithCoordinates(latitude: geoLat, longitude: geoLon)
//
//                        DispatchQueue.main.async {
//                            if let state = geocodeData[0].state {
//                                self.userLocation = "\(geoCityName), \(state)"
//                            } else {
//                                self.userLocation = "\(geoCityName), \(geoCountryName)"
//                            }
//                        }
//
//
//
//                    }
//
//                } catch {
//                    print("Error decoding geocode data: \(error)")
//                }
//            }
//        }
//        task.resume()
//    }
//
//}
