//
//  SavedLocationCell.swift
//  Weather
//
//  Created by Tomas Sanni on 6/6/23.
//

import SwiftUI

struct SavedLocationCell: View {
    @ObservedObject var location: LocationEntity
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack {
            Color.teal.opacity(0.000001)
            HStack {
                SavedLocationImageView(imageName: location.sfSymbol ?? "")
                
                VStack(alignment: .leading) {
                    Text(location.name ?? "no name")
                        .font(.headline)
                    
                    HStack(alignment: .top, spacing: 0.0) {
                        Text(nffn)
                        Text(" • ")
                        Text(location.weatherCondition ?? "")
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                
            }
        }
        .foregroundStyle(.white)
    }
    
    func udfn(temp: String, unitType: UnitTemperature) {
        
    }
    
    var nffn: String {
        let savedTemperature = location.temperature ?? ""
        let savedTempConvertedToDouble = Double(savedTemperature) ?? 0
        let unitTemperatureFromSavedTemperature = Measurement(value: savedTempConvertedToDouble, unit: getUnitTemperature())
        
        print(unitTemperatureFromSavedTemperature)
        
        return unitTemperatureFromSavedTemperature.value.description
    }
    

    
    /// Takes a Double, removes floating point numbers, then converts to and returns a String
    private func convertNumberToZeroFloatingPoints(number: Double) -> String {
        let convertedStringNumber = String(format: "%.2f", number)
        return convertedStringNumber
    }
    
    /// Checks UserDefaults for UnitTemperature selection. Returns the saved Unit Temperature.
    private func getUnitTemperature() -> UnitTemperature {
        let savedUnitTemperature = UserDefaults.standard.string(forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        switch savedUnitTemperature {
        case K.TemperatureUnits.fahrenheit:
            return .fahrenheit
        case K.TemperatureUnits.celsius:
            return .celsius
        case   K.TemperatureUnits.kelvin:
            return .kelvin
        default:
            return .fahrenheit
        }
    }
}

//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(location: TodayWeatherModel.holderData)
//    }
//}
