//
//  AppStateViewModelTests.swift
//  TenkiWeatherTests
//
//  Created by Tomas Sanni on 5/27/25.
//

import XCTest
@testable import Tenki_Weather

final class AppStateViewModelTests: XCTestCase {
    // Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
    // Naming Structure: test_[struct or class]_[variable or function]_[expected result]

    // Testing Structure: Given, When, Then
    var mockWeatherService: MockWeatherService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockWeatherService = MockWeatherService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockWeatherService = nil
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
    
    
    @MainActor func test_AppStateViewModel_getWeather_shouldSucced() async {
        // Given
        let weatherVM = WeatherViewModel(weatherService: mockWeatherService)
        let locationVM = CoreLocationViewModel()
        let persistenceVM = SavedLocationsPersistenceViewModel(weatherManager: mockWeatherService, coreLocationModel: locationVM)
        
        let vm = AppStateViewModel(locationViewModel: locationVM, weatherViewModel: weatherVM, persistence: persistenceVM)
        
        // When
        await vm.getWeather()
        
        // Then
        XCTAssertFalse(vm.loading)
        XCTAssertTrue(vm.resetViews)
        XCTAssertEqual(vm.lastUpdated, Helper.getReadableMainDate(date: Date.now, timezoneIdentifier: TimeZone.current.identifier))
    }
    
    
    @MainActor func test_AppStateViewModel_getWeather_retrievingWeatherServiceDataShouldFail() async {
        // Given
        mockWeatherService.shouldFail = true
        let weatherVM = WeatherViewModel(weatherService: mockWeatherService)
        let locationVM = MockCoreLocationViewModel()
        let persistenceVM = SavedLocationsPersistenceViewModel(weatherManager: mockWeatherService, coreLocationModel: locationVM)
        
        let vm = AppStateViewModel(locationViewModel: locationVM, weatherViewModel: weatherVM, persistence: persistenceVM)
        
        // When
        await vm.getWeather()
        
        // Then
        XCTAssertTrue(vm.showWeatherErrorAlert)
    }

}
