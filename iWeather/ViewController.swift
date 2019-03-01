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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

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
    
    @objc func longPressCall(_ recognizer: UIGestureRecognizer) {
        
        
        
        let longPressedAtPoint = recognizer.location(in: self.weatherMapView)
        let longPressedAtCoordinate : CLLocationCoordinate2D = weatherMapView.convert(longPressedAtPoint, toCoordinateFrom: self.weatherMapView) 
        
        
        newPin.coordinate = longPressedAtCoordinate
        weatherMapView.addAnnotation(newPin)
        
        WeatherWebService().getWeatherForCoordinates(coordinateValue: longPressedAtCoordinate, from: self)
        
        
        
    }
    
    func updateWeatherValue(weatherModelObject : WeatherModel)  {
        
        self.placeName.text = weatherModelObject.placeName
        self.minTemperature.text = String(format: "%.2f", "\(weatherModelObject.minTemp)")
        self.maxTemperature.text = String(format: "%.2f", "\(weatherModelObject.maxTemp)")
        self.weatherStatus.text = weatherModelObject.mainValue
        self.weatherDescription.text = weatherModelObject.description
        self.weatherIcon.sd_setShowActivityIndicatorView(true)
        self.weatherIcon.sd_setImage(with: URL(string: WEATHERICONURL.replacingOccurrences(of: "ICONVALUE", with: ICONVALUE)), placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
    }
    
    
    
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

