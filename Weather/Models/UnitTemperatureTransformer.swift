//
//  UnitTemperatureTransformer.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 2/21/24.
//

import Foundation


class UnitTemperatureTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let temperature = value as? UnitTemperature else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: temperature, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let temperature = value as? Data else { return nil }
        
        do {
            let temperature = try NSKeyedUnarchiver.unarchivedObject(ofClass: UnitTemperature.self, from: temperature)
            return temperature
        } catch {
            return nil
        }
    }
}
