//
//  MockApiService.swift
//  WeatherAppTests
//
//  Created by Ayush Goyal on 22/05/24.
//

import Foundation
@testable import WeatherApp

class MockApiService : WeatherDetailServiceDelegate {
    
    var results : Result<WeatherResponse, NetworkError>!
    
    func getWeatherDetails(_ urlString: String, completion: @escaping (Result<WeatherApp.WeatherResponse, WeatherApp.NetworkError>) -> Void) {
        completion(results)
    }
    

}
