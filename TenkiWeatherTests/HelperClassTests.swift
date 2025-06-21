//
//  HelperClassTests.swift
//  TenkiWeatherTests
//
//  Created by Tomas Sanni on 6/20/25.
//

//TODO: Finish adding tests

import XCTest
@testable import Tenki_Weather

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
        // Given
        defaults.set(false, forKey: K.UserDefaultKeys.showTemperatureUnitKey)
        
        // When
        let result = Helper.getShowTemperatureUnitPreference(from: defaults)
        
        // Then
        XCTAssertEqual(result, false)
    }
    
    func test_Helper_getShowTemperatureUnitPreference_shouldBeTrue() {
        // Given
        defaults.set(true, forKey: K.UserDefaultKeys.showTemperatureUnitKey)
        
        // When
        let result = Helper.getShowTemperatureUnitPreference(from: defaults)
        
        // Then
        XCTAssertEqual(result, true)
    }
    
    func test_Helper_convertNumberToZeroFloatingPoints_shouldPrintNoFloatingPoints() {
        // Given
        let number: Double = 123456789.123456789
        
        //When
        let result = Helper.convertNumberToZeroFloatingPoints(number: number)
        
        // Then
        XCTAssertEqual(result, "123456789")
    }
    
    func test_Helper_convertNumberToZeroFloatingPoints_shouldPrintTwoFloatingPoints() {
        // Given
        let number: Double = 123456789.123456789
        
        //When
        let result = Helper.convertNumberToTwoFloatingPoints(number: number)
        
        // Then
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
        defaults.set(false, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableMainDate(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "Jul 10, 1:00 PM")
    }
    
    func test_Helper_getReadableMainDate_shouldReturnDateInMilitary() {
        UserDefaults.standard.set(true, forKey: K.UserDefaultKeys.timePreferenceKey)
        let date = ISO8601DateFormatter().date(from: "2025-07-10T18:00:00Z")!
        let result = Helper.getReadableMainDate(date: date, timezoneIdentifier: "America/Chicago")
        
        XCTAssertEqual(result, "10 Jul, 13:00")
        UserDefaults.standard.removeObject(forKey: K.UserDefaultKeys.timePreferenceKey)

    }

}
