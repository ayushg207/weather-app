//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 21/05/24.
//

import Foundation

class WeatherDetail : WeatherLocation {

    
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
    
    var description = ""
    var icon = ""
    var temp = 0.0
    var dt : NSDate!
    var iconUrl : String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
        
    func getData(completed : @escaping () -> ()){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.latitude)&lon=\(self.longitude)&units=metric&appid=\(APIKeys.openWeatherKey)"
     
        
        guard let url = URL(string : urlString) else {
            print("Error creating URL object")
            completed()
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url){ (data, response, error) in
            
            if let error = error {
                print("failed to fetch data, error : \(error.localizedDescription)")
            }
            
            do {
                let result = try JSONDecoder().decode(WeatherResponse.self, from : data!)
                self.temp = result.main?.temp ?? 0
                self.description = result.weather?[0].description ?? ""
                self.dt = NSDate(timeIntervalSince1970: TimeInterval(result.dt ?? 0) )
                self.icon = result.weather?[0].icon ?? ""
                
            }
            catch{
                print("Error : \(error.localizedDescription)")
            }
            completed()
        }
        
        task.resume()
    }
}
