//
//  WeatherModel.swift
//  iWeather
//
//  Created by Akhil  Mathew on 01/03/19.
//  Copyright © 2019 Akhil. All rights reserved.
//

import Foundation

struct WeatherModel:Decodable {
    
    let name: String
    
    
    
    let weather: [WeatherDetails]
    
    let main: Main
    
    
    
    
}

struct WeatherDetails: Decodable {
    let description: String
    let icon: String
    let id: Int
    let main: String
}




struct Main: Decodable {
    let humidity: Int = 0
    let pressure: Int = 0
    let temp: Double
    let tempMax: Double = 0
    let tempMin: Double = 0
    private enum CodingKeys: String, CodingKey {
        case humidity, pressure, temp, tempMax = "temp_max", tempMin = "temp_min"
    }
}










