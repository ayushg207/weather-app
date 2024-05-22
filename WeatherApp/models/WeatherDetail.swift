//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 21/05/24.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]?
    let main: Main?
    let dt : Int?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon : String?
}

struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

class WeatherDetail : WeatherLocation {
    
    var description = ""
    var icon = ""
    var temp = 0.0
    var dt = NSDate(timeIntervalSince1970: TimeInterval(0))
    var iconUrl : String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
 
    var weatherDetailService : WeatherDetailServiceDelegate
    
    init(weatherDetailService : WeatherDetailServiceDelegate, name : String, latitude : Double, longitude: Double){
        self.weatherDetailService = weatherDetailService
        super.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func getData(completion : @escaping () -> ()){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude)&lon=\(self.longitude)&units=metric&appid=\(APIKeys.openWeatherKey)"
        weatherDetailService.getWeatherDetails(urlString) {
            (result) in
            
            switch result {
            case .failure(let error):
                    print(error.errorMessage as String)
                
            case .success(let weatherData) :
                self.temp = weatherData.main?.temp ?? 0
                self.description = weatherData.weather?[0].description ?? ""
                self.dt = NSDate(timeIntervalSince1970: TimeInterval(weatherData.dt ?? 0) )
                self.icon = weatherData.weather?[0].icon ?? ""
            }
            completion()
        }
    }
}
