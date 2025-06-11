//
//  WeatherViewModelTests.swift
//  WeatherViewModelTests
//
//  Created by Tomas Sanni on 5/27/25.
//

import XCTest
@testable import Tenki_Weather

final class WeatherViewModelTests: XCTestCase {
    // Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
    // Naming Structure: test_[struct or class]_[variable or function]_[expected result]

    // Testing Structure: Given, When, Then

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_WeatherViewModel_fetchWeather_success() async  {
        // Given
        let weatherService = MockWeatherService()
        let vm = WeatherViewModel(weatherService: weatherService)
        // When
        await vm.fetchWeather(latitude: 35.6895, longitude: 139.6917, timezoneIdentifier: "Asia/Tokyo")
        //Then
        XCTAssertEqual(vm.currentWeather, TodayWeatherModelPlaceHolder.holderData)
        XCTAssertEqual(vm.tomorrowWeather, DailyWeatherModelPlaceHolder.placeholder)
        XCTAssertEqual(vm.dailyWeather, DailyWeatherModelPlaceHolder.placeholderArray)
        XCTAssertEqual(vm.weatherAlert, WeatherAlertModelPlaceholder.weatherAlertHolder)
        XCTAssertEqual(vm.localWeather, TodayWeatherModelPlaceHolder.holderData)

    }

}
