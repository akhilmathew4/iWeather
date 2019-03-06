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
    
    var weatherModelObject : WeatherModel?
    
    func getWeatherForCoordinates(coordinateValue : CLLocationCoordinate2D, completionHandler : @escaping (_ uiValues:[String : Any], _ error : Error?)->Void  )  {
        LATVALUE = "\(coordinateValue.latitude)"
        LONGVALUE = "\(coordinateValue.longitude)"
        let parameters =  [
            "lat" : LATVALUE,
            "lon" : LONGVALUE,
            "APPID" : APPKEY
            
        ]
        
        WebServiceManager().getDetailsFromURL(url: WEATHERBASEURL, withQueryParameters: parameters) { (responseDictionary, error) in
            if (responseDictionary != nil){
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseDictionary as Any, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let forecast = try decoder.decode(WeatherModel.self, from: jsonData)
                    print(forecast.name)
                    ICONVALUE = (forecast.weather.first!.icon)
                    self.weatherModelObject = forecast
                    let uiValue = ["placeName" : self.weatherModelObject?.name as Any,
                                   "temp" : self.weatherModelObject?.main.temp as Any,
                                   "status" : self.weatherModelObject?.weather.first?.main as Any,
                                   "description" : self.weatherModelObject?.weather.first?.description as Any
                    ]
                    completionHandler(uiValue,nil)
                } catch {
                    print("Error")
                }
                
            }
            else{
                print("Error: " + error!.localizedDescription)
            }
            
        }
    }
    
    
    
    
    
}
