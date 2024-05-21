//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Ayush Goyal on 20/05/24.
//

import Foundation

class WeatherLocation : Codable{
    var name : String
    var latitude : Double
    var longitude : Double
    
    init (name : String, latitude : Double, longitude: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}



