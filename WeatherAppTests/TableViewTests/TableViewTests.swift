//
//  TableViewTests.swift
//  WeatherAppTests
//
//  Created by Ayush Goyal on 22/05/24.
//

import XCTest
@testable import WeatherApp

final class TableViewTests: XCTestCase {
    
    var sut : LocationListViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name : "Main", bundle : nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: LocationListViewController.self)) as? LocationListViewController
        sut.loadViewIfNeeded()
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as? PageViewController
        pageViewController?.loadViewIfNeeded()
        sut.weatherLocations = pageViewController?.weatherLocations ?? []
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
        
    }
    
    func test_tableViewDelegates_shouldBeConnected() throws{
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func test_tableViewRowCount() throws{
        XCTAssertEqual(getRowCount(in: sut.tableView),sut.weatherLocations.count,"Table rows equal")
    }
    
    func test_tableView_contentCheck() throws{
        
        for (idx,weatherLocation) in sut.weatherLocations.enumerated() {
            let cell = getCellAtRow(in: sut.tableView,row : idx)
            XCTAssertEqual(cell?.textLabel?.text,weatherLocation.name, "cell value at \(idx)")
            XCTAssertEqual(cell?.detailTextLabel?.text, "Lat:\(weatherLocation.latitude) Long:\(weatherLocation.longitude)")
        }
    }
  
    func test_tableView_deleteCell() throws {
        let weatherLocationsCountBeforeDeletion = sut.weatherLocations.count
        deleteCellMock(in: sut.tableView, row: 0)
        XCTAssertEqual(sut.weatherLocations.count, weatherLocationsCountBeforeDeletion-1)
        XCTAssertEqual(getRowCount(in: sut.tableView), weatherLocationsCountBeforeDeletion-1,"Delete operation performed")
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

}
