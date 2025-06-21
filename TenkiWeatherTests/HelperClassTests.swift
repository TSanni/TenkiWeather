//
//  HelperClassTests.swift
//  TenkiWeatherTests
//
//  Created by Tomas Sanni on 6/20/25.
//


import XCTest
@testable import Tenki_Weather
import WeatherKit

final class HelperClassTests: XCTestCase {
    // Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
    // Naming Structure: test_[struct or class]_[variable or function]_[expected result]

    // Testing Structure: Given, When, Then
    
    let defaults = UserDefaults(suiteName: #file)!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        defaults.removePersistentDomain(forName: #file)

    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Helper_getShowTemperatureUnitPreference_shouldBeFalse() {
        defaults.set(false, forKey: K.UserDefaultKeys.showTemperatureUnitKey)
        
        let result = Helper.getShowTemperatureUnitPreference(from: defaults)
        
        XCTAssertEqual(result, false)
    }
    
    func test_Helper_getShowTemperatureUnitPreference_shouldBeTrue() {
        defaults.set(true, forKey: K.UserDefaultKeys.showTemperatureUnitKey)
        
        let result = Helper.getShowTemperatureUnitPreference(from: defaults)
        
        XCTAssertEqual(result, true)
    }
    
    func test_Helper_convertNumberToZeroFloatingPoints_shouldPrintNoFloatingPoints() {
        let number: Double = 123456789.123456789
        
        let result = Helper.convertNumberToZeroFloatingPoints(number: number)
        
        XCTAssertEqual(result, "123456789")
    }
    
    func test_Helper_convertNumberToZeroFloatingPoints_shouldPrintTwoFloatingPoints() {
        let number: Double = 123456789.123456789
        
        let result = Helper.convertNumberToTwoFloatingPoints(number: number)
        
        XCTAssertEqual(result, "123456789.12")
    }
    
    func test_Helper_getUnitTemperature_shouldReturnCelsius() {
        defaults.set("celsius", forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        let result = Helper.getUnitTemperature(from: defaults)
        
        XCTAssertEqual(result, UnitTemperature.celsius)
    }
    
    func test_Helper_getUnitTemperature_shouldReturnFahrenheit() {
        defaults.set("fahrenheit", forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        let result = Helper.getUnitTemperature(from: defaults)
        
        XCTAssertEqual(result, UnitTemperature.fahrenheit)
    }
    
    func test_Helper_getUnitTemperature_shouldReturnKelvin() {
        defaults.set("kelvin", forKey: K.UserDefaultKeys.unitTemperatureKey)
        
        let result = Helper.getUnitTemperature(from: defaults)
        
        XCTAssertEqual(result, UnitTemperature.kelvin)
    }
    
    func test_Helper_isMilitaryTime_shouldReturnTrue() {
        defaults.set(true, forKey: K.UserDefaultKeys.timePreferenceKey)
        
        let result = Helper.isMilitaryTime(from: defaults)
        
        XCTAssertEqual(result, true)
    }
    
    func test_Helper_isMilitaryTime_shouldReturnFalse() {
        defaults.set(false, forKey: K.UserDefaultKeys.timePreferenceKey)
        
        let result = Helper.isMilitaryTime(from: defaults)
        
        XCTAssertEqual(result, false)
    }
    
    func test_Helper_getReadableMainDate_shouldReturnDateInStandardFormat() {
        UserDefaults.standard.set(false, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableMainDate(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "Jul 10, 1:00 PM")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getReadableMainDate_shouldReturnDateInMilitary() {
        UserDefaults.standard.set(true, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableMainDate(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "10 Jul, 13:00")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getReadableHourOnly_shouldReturnDateInStandardFormat() {
        UserDefaults.standard.set(false, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableHourOnly(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "1 PM")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getReadableHourOnly_shouldReturnDateInMilitaryFormat() {
        UserDefaults.standard.set(true, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableHourOnly(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "13:00")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getDayOfWeekAndDate_shouldReturnDateInStandardFormat() {
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getDayOfWeekAndDate(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "Thursday, Jul 10")
    }
    
    func test_Helper_getReadableHourAndMinute_shouldReturnDateInStandardFormat() {
        UserDefaults.standard.set(false, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableHourAndMinute(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "1:00 PM")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getReadableHourAndMinute_shouldReturnDateInMilitaryFormat() {
        UserDefaults.standard.set(true, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableHourAndMinute(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "13:00")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)
    }
    
    func test_Helper_getUnitLength_shouldReturnMiles() {
        UserDefaults.standard.set("miles", forKey: K.UserDefaultKeys.unitDistanceKey)
        let result = Helper.getUnitLength()
        
        XCTAssertEqual(result, .miles)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.unitDistanceKey)
    }
    
    func test_Helper_getUnitLength_shouldReturnKilometers() {
        UserDefaults.standard.set("kilometers", forKey: K.UserDefaultKeys.unitDistanceKey)
        let result = Helper.getUnitLength()
        
        XCTAssertEqual(result, .kilometers)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.unitDistanceKey)
    }
    
    func test_Helper_getUnitLength_shouldReturnMeters() {
        UserDefaults.standard.set("meters", forKey: K.UserDefaultKeys.unitDistanceKey)
        let result = Helper.getUnitLength()
        
        XCTAssertEqual(result, .meters)
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.unitDistanceKey)
    }
    
    func test_Helper_getUnitSpeed_shouldReturnMilesPerHour() {
        defaults.set("miles", forKey: K.UserDefaultKeys.unitDistanceKey)
        
        let result = Helper.getUnitSpeed(from: defaults)
        
        XCTAssertEqual(result, .milesPerHour)
    }
    
    func test_Helper_getUnitSpeed_shouldReturnKilometersPerHour() {
        defaults.set("kilometers", forKey: K.UserDefaultKeys.unitDistanceKey)
        
        let result = Helper.getUnitSpeed(from: defaults)
        
        XCTAssertEqual(result, .kilometersPerHour)
    }
    
    func test_Helper_getUnitSpeed_shouldReturnMetersPerSecond() {
        defaults.set("meters", forKey: K.UserDefaultKeys.unitDistanceKey)
        
        let result = Helper.getUnitSpeed(from: defaults)
        
        XCTAssertEqual(result, .metersPerSecond)
    }
    
    
    func test_Helper_getUnitPressure_shouldReturnInchesOfMercury() {
        defaults.set("inchesOfMercury", forKey: K.UserDefaultKeys.unitPressureKey)
        
        let result = Helper.getUnitPressure(from: defaults)
        
        XCTAssertEqual(result, .inchesOfMercury)
    }
    
    func test_Helper_getUnitPressure_shouldReturnBars() {
        defaults.set("bars", forKey: K.UserDefaultKeys.unitPressureKey)
        
        let result = Helper.getUnitPressure(from: defaults)
        
        XCTAssertEqual(result, .bars)
    }
    
    func test_Helper_getUnitPressure_shouldReturnMillibars() {
        defaults.set("millibars", forKey: K.UserDefaultKeys.unitPressureKey)
        
        let result = Helper.getUnitPressure(from: defaults)
        
        XCTAssertEqual(result, .millibars)
    }
    
    func test_Helper_getUnitPressure_shouldReturnmillimetersOfMercury() {
        defaults.set("millimetersOfMercury", forKey: K.UserDefaultKeys.unitPressureKey)
        
        let result = Helper.getUnitPressure(from: defaults)
        
        XCTAssertEqual(result, .millimetersOfMercury)
    }
    
    func test_Helper_getUnitPrecipitation_shouldReturnInches() {
        defaults.set("inches", forKey: K.UserDefaultKeys.unitLengthKey)
        
        let result = Helper.getUnitPrecipitation(from: defaults)
        
        XCTAssertEqual(result, .inches)
    }
    
    func test_Helper_getUnitPrecipitation_shouldReturnMillimeters() {
        defaults.set("millimeters", forKey: K.UserDefaultKeys.unitLengthKey)
        
        let result = Helper.getUnitPrecipitation(from: defaults)
        
        XCTAssertEqual(result, .millimeters)
    }
    
    func test_Helper_getUnitPrecipitation_shouldReturnCentimeters() {
        defaults.set("centimeters", forKey: K.UserDefaultKeys.unitLengthKey)
        
        let result = Helper.getUnitPrecipitation(from: defaults)
        
        XCTAssertEqual(result, .centimeters)
    }
    
    func test_Helper_getRotation_shouldReturnDegreesForNorthDirection() {
        let direction = Wind.CompassDirection.north
        let zero: Double = 45
        let result = Helper.getRotation(direction: direction)
        
        XCTAssertEqual(result, zero - 90)
    }
    
    
    func test_Helper_getImage_shouldReturnNoFillSFImageString() {
        let imageName = "wind"
        let result = Helper.getImage(imageName: imageName)
        
        XCTAssertEqual(result, imageName)
    }
    
    func test_Helper_getImage_shouldReturnFillSFImageString() {
        let imageName = "sun.max"
        let result = Helper.getImage(imageName: imageName)
        
        XCTAssertEqual(result, imageName + ".fill")
    }
}
