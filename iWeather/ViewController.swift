//
//  ViewController.swift
//  iWeather
//
//  Created by Akhil  Mathew on 28/02/19.
//  Copyright © 2019 Akhil. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SDWebImage

class ViewController: UIViewController  {
    
    let locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    @IBOutlet var weatherMapView: MKMapView!
    @IBOutlet var placeName: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var weatherStatus: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        
        
        let longPressSelected = UILongPressGestureRecognizer(target: self, action:#selector(ViewController.longPressCall(_:)))
        longPressSelected.minimumPressDuration = 1
        weatherMapView.addGestureRecognizer(longPressSelected)
        
        
        
        
    }
    
    func convertKelvinToFahrenheit(temperature:Double) -> Double {
        let fahrenheitTemp = (temperature - 273.15) * (9/5) + 32
        return fahrenheitTemp
    }
    
    @objc func longPressCall(_ recognizer: UIGestureRecognizer) {
        
        
        
        let longPressedAtPoint = recognizer.location(in: self.weatherMapView)
        let longPressedAtCoordinate : CLLocationCoordinate2D = weatherMapView.convert(longPressedAtPoint, toCoordinateFrom: self.weatherMapView)
        
        
        newPin.coordinate = longPressedAtCoordinate
        weatherMapView.addAnnotation(newPin)
        let weatherWebServiceObject = WeatherWebService()
        weatherWebServiceObject.getWeatherForCoordinates(coordinateValue: longPressedAtCoordinate) { (uiValues, error) in
            self.willUpdateUI(with: uiValues)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}

extension ViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.weatherMapView.removeAnnotation(newPin)
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        self.weatherMapView.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        self.weatherMapView.addAnnotation(newPin)
        
    }
    
}

extension ViewController {
    func willUpdateUI(with uiValues: [String : Any]) {
        self.placeName.text = uiValues["placeName"] as? String
        self.minTemperature.text = String(format: "%.2f", self.convertKelvinToFahrenheit(temperature: uiValues["temp"] as! Double))
        
        self.weatherStatus.text = uiValues["status"] as? String
        self.weatherDescription.text = uiValues["description"] as? String
        self.weatherIcon.sd_setShowActivityIndicatorView(true)
        self.weatherIcon.sd_setIndicatorStyle(.gray)
        self.weatherIcon.sd_setImage(with: URL(string: WEATHERICONURL.replacingOccurrences(of: "ICONVALUE", with: ICONVALUE)), placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
    }
    
    
    
    
    
}

