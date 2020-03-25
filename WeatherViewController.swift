//
//  WeatherViewController.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 29/12/16.
//  Copyright © 2016 jacob  johar. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class WeatherViewController: UIViewController, MKMapViewDelegate
{
    //IB OUTLETS
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentWeather: UITextField!
    @IBOutlet weak var currentWeatherDescription: UITextField!
    @IBOutlet weak var temperature: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var min_temp: UITextField!
    @IBOutlet weak var max_temp: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    var City: City!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad()
    {
    super.viewDidLoad()
        
        activityView.center = self.view.center
       
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
            super.viewWillAppear(animated)
            self.initialisation(initial: false)
            let coordinate = CLLocationCoordinate2DMake(self.City.latitude, self.City.longitude)
            let Place = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.map.setRegion(Place, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.map.addAnnotation(annotation)
            
            //for stopping the activity indicator
            self.activityView.stopAnimating()
            self.initialisation1()
        
    }
    //method for enabling each iboutlets initially
    func initialisation(initial: Bool)
    {
        //activity view is added
        
        activityView.startAnimating()
        self.view.addSubview(self.activityView)

        cityName.isEnabled = initial
        currentWeather.isEnabled = initial
        currentWeatherDescription.isEnabled = initial
        temperature.isEnabled = initial
        pressure.isEnabled = initial
        humidity.isEnabled = initial
        min_temp.isEnabled = initial
        max_temp.isEnabled = initial
    }
    //initialising each textfields considered
    
    func initialisation1()
    {
        self.cityName.text = self.City.cityName
        self.currentWeather.text = self.City.weather
        self.currentWeatherDescription.text = self.City.weatherDescription
        self.temperature.text = "\(self.City.temperature)°C"
        self.pressure.text = "\(self.City.pressure) hPa"
        self.humidity.text = "\(self.City.humidity)%"
        self.min_temp.text = "\(self.City.min_temp)°C"
        self.max_temp.text = "\(self.City.max_temp)°C"
    }
    @IBAction func done(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }


        

}

