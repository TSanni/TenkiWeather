//
//  CoreLocationViewModelTests.swift
//  TenkiWeatherTests
//
//  Created by Tomas Sanni on 6/13/25.
//

import XCTest
@testable import Tenki_Weather

// TODO: - Add more tests
final class CoreLocationViewModelTests: XCTestCase {
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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_CoreLocationViewModel_latitudeAndLongitude_shouldBeDefaultValue() {
        // Given
        let locationVM = MockCoreLocationViewModel()
                
        // Then
        print("---VALUE: \(locationVM.latitude)---")
        XCTAssertEqual(locationVM.latitude, 29.7603761)
        XCTAssertEqual(locationVM.longitude, -95.3698054)
        

    }
    

}
