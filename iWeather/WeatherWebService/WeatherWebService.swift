//
//  WeatherWebService.swift
//  iWeather
//
//  Created by Akhil  Mathew on 28/02/19.
//  Copyright © 2019 Akhil. All rights reserved.
//

import Foundation
import CoreLocation
import AFNetworking

class WeatherWebService{
    
    func getWeatherForCoordinates(coordinateValue:CLLocationCoordinate2D, from viewController:ViewController)  {
        let weatherModelObject = WeatherModel()
        LATVALUE = "\(coordinateValue.latitude)"
        LONGVALUE = "\(coordinateValue.longitude)"
        
       
        
        let manager = AFHTTPSessionManager()
        
        manager.get(
            WEATHERBASEURL,
            parameters: [
                "lat" : LATVALUE,
                "lon" : LONGVALUE,
                "APPID" : APPKEY
                
        ],
            progress: { (Progress) in
            
        },
            success: {
                (operation, responseObject) in
            
                    if let responseDictionary = responseObject as? [String: Any] {
                        print(responseDictionary)
                        let weatherDictionary = (responseDictionary["weather"] as! [Any]).first as! [String : Any]
                        
                        weatherModelObject.mainValue = weatherDictionary["main"] as! String
                        weatherModelObject.description = weatherDictionary["description"] as! String
                        weatherModelObject.icon = weatherDictionary["icon"] as! String
                        weatherModelObject.placeName = responseDictionary["name"] as! String
                        
                        let temperatureDictionary = responseDictionary["main"] as? [String : Any]
                        
                        weatherModelObject.maxTemp = self.convertKelvinToFahrenheit(temperature: temperatureDictionary?["temp_max"] as! Double)
                        weatherModelObject.minTemp = self.convertKelvinToFahrenheit(temperature: temperatureDictionary?["temp_min"] as! Double)
                        ICONVALUE = weatherModelObject.icon
                        viewController.updateWeatherValue(weatherModelObject: weatherModelObject)
            }
        },
            failure: {
                (operation, error) in
                    print("Error: " + error.localizedDescription)
        })
        
        
        
    }
    
    func convertKelvinToFahrenheit(temperature:Double) -> Double {
        let fahrenheitTemp = (temperature - 273.15) * (9/5) + 32
        return fahrenheitTemp
    }
}
