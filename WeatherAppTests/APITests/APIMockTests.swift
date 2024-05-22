//
//  APIMockTests.swift
//  WeatherAppTests
//
//  Created by Ayush Goyal on 21/05/24.
//

import XCTest
@testable import WeatherApp

final class APIMockTests: XCTestCase {
    
    var sut : LocationDetailViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let storyboard = UIStoryboard(name : "Main", bundle : nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: LocationDetailViewController.self)) as? LocationDetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    
    func testAPIFail() throws{
        let mockService = MockApiService()
        mockService.results = .failure(NetworkError("Error in api"))
        sut.weatherDetailService = mockService
        sut.locationIndex = 0
        sut.updateUserIterface()
        let seconds = 1.0
        let expectation = XCTestExpectation(description: "All the labels are set to initial values")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){            XCTAssertEqual(self.sut.dateLabel.text,String(describing:NSDate(timeIntervalSince1970: TimeInterval(0))),"Date label")
            XCTAssertEqual(self.sut.temperatureLabel.text, "0.0°", "Temperature label")
            XCTAssertEqual(self.sut.summaryLabel.text, "", "Summary label")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.5)
    }
    
    func testAPISuccess() throws {
        let mockService = MockApiService()
        let sampleWeatherResponse = WeatherResponse(weather: Optional([WeatherApp.Weather(id: Optional(721), main: Optional("Haze"), description: Optional("haze"), icon: Optional("50d"))]), main: Optional(WeatherApp.Main(temp: Optional(33.98), feelsLike: Optional(40.98), tempMin: Optional(32.94), tempMax: Optional(33.98), pressure: Optional(1004), humidity: Optional(70), seaLevel: nil, grndLevel: nil)), dt: Optional(1716357700))
        mockService.results = .success(sampleWeatherResponse)
        sut.weatherDetailService = mockService
        sut.locationIndex = 0
        sut.updateUserIterface()
        
        let seconds = 1.0
        let expectation = XCTestExpectation(description: "All the labels are set to sample values")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
            XCTAssertEqual(self.sut.dateLabel.text,String(describing:NSDate(timeIntervalSince1970: TimeInterval(1716357700))),"Date label")
            XCTAssertEqual(self.sut.temperatureLabel.text, "33.98°", "Temperature label")
            XCTAssertEqual(self.sut.summaryLabel.text, "haze", "Summary label")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.5)
    }
        
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
