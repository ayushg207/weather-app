//
//  WeatherDetailService.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 21/05/24.
//

import Foundation

class NetworkError : Error {
    var errorMessage : String!
    
    init(_ errorMessage : String){
        self.errorMessage = errorMessage
    }
}

protocol WeatherDetailServiceDelegate {
    func getWeatherDetails(_ urlString : String, completion : @escaping (Result<WeatherResponse, NetworkError>)-> Void)
}

class WeatherDetailService : WeatherDetailServiceDelegate {
    func getWeatherDetails(_ urlString : String, completion : @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
        guard let url = URL(string : urlString) else {
            let errorMessage = "Error creating URL object"
            completion(.failure(NetworkError(errorMessage)))
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url){ (data, response, error) in
            
            var errorMessage = ""
            if let error = error {
                errorMessage = "failed to fetch data, error : \(error.localizedDescription)"
            }
            
            do {
                let result = try JSONDecoder().decode(WeatherResponse.self, from : data!)
                completion(.success(result))
//                self.temp = result.main?.temp ?? 0
//                self.description = result.weather?[0].description ?? ""
//                self.dt = NSDate(timeIntervalSince1970: TimeInterval(result.dt ?? 0) )
//                self.icon = result.weather?[0].icon ?? ""
                
            }
            catch{
                errorMessage += "Error : \(error.localizedDescription)"
            }
            completion(.failure(NetworkError(errorMessage)))
        }
        
        task.resume()
        
    }
}


