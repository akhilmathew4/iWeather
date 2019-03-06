//
//  WebServiceManager.swift
//  iWeather
//
//  Created by Akhil  Mathew on 06/03/19.
//  Copyright © 2019 Akhil. All rights reserved.
//

import Foundation
import AFNetworking

class WebServiceManager {
    
    func getDetailsFromURL(url:String, withQueryParameters parameters: [String: Any], completionHandler:@escaping (_ responseDictionary : [String : Any]? , _ error : Error?)->Void) {
        
         let manager = AFHTTPSessionManager()
        
        manager.get(
                    url,
                    parameters: parameters,
            progress: {
                        (Progress) in
                
                
                
                
        },  success: {
                        (operation, responseObject) in
            
            if let responseDictionary = responseObject as? [String : Any] {
                
                
                completionHandler(responseDictionary, nil)
            }
            
        },  failure: {
                        (operation, error) in
            
            completionHandler (nil, error)
            
        })
        
        
    }
    
}
