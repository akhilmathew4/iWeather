//
//  iWeatherTests.swift
//  iWeatherTests
//
//  Created by Akhil  Mathew on 28/02/19.
//  Copyright © 2019 Akhil. All rights reserved.
//

import XCTest
import CoreLocation
@testable import iWeather

class iWeatherTests: XCTestCase {
    let webServiceObject = WebServiceManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        LATVALUE = "\(28.54)"
        LONGVALUE = "\(75.64)"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeatherResponse(){
        
        let expectation = self.expectation(description: "Weather response parse expectation")
        let parameters =  [
            "lat" : LATVALUE,
            "lon" : LONGVALUE,
            "APPID" : APPKEY
            
        ]
        webServiceObject.getDetailsFromURL(url: WEATHERBASEURL, withQueryParameters: parameters) { (responseDictionary, error) in
            
            XCTAssertNil(error)
            guard let responseDictionary = responseDictionary else{
                XCTFail()
                return
            }
            
            do{
                let jsonData = try JSONSerialization.data(withJSONObject: responseDictionary as Any, options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let forecast = try decoder.decode(WeatherModel.self, from: jsonData)
                XCTAssertNotNil(forecast)
                expectation.fulfill()
            }catch {
                XCTFail(error.localizedDescription)
            }
        }
        self.waitForExpectations(timeout: 10.0, handler: nil)
        
        
    }
    
    
    
}
