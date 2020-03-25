//
//  MapViewController.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate
{
    //IB OUTLETS
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var map: MKMapView!
    //activity indicator is added
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //save to core data
    let vc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //create fetch request
    var fetchr: NSFetchRequest<City> = City.fetchRequest()
    var app = (UIApplication.shared.delegate as! AppDelegate)
    //creating instance of class Networking()
    let invoking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        let annotations = self.map.annotations
        self.map.removeAnnotations(annotations)
        let information:[City]!
        do{
            information = try self.vc.fetch(self.fetchr)
        }
        catch{
            
            print("RETRIEVAL OF DATA IMPOSSIBLE")
            return
        }
        if information.count > 0
        {
            for value in information
            {
                performUIUpdatesOnMain {
                    let lat = value.latitude
                    let lon = value.longitude
                    Properties.latitude = lat
                    Properties.longitude = lon
                    //invokig the method of Networking class
                    self.invoking.AccessingWeatherWRTMap(latitude: value.latitude,longitude: value.longitude,completionHandlerForgetWeatherUsingMap: { (sucess, error) in
                        if sucess
                        {
                            //debug print
                            print("done")
                        }
                        else{
                            performUIUpdatesOnMain {
                                //displaying alert
                                self.displayAlert(title: "cannot retrieve weather details", message: "plz check your connection")
                            }
                        }
                    })
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    self.map.removeAnnotation(annotation)
                    self.map.addAnnotation(annotation)
                }
            }
        }
        map.reloadInputViews()
        
    }
    
    @IBAction func AddPin(_ sender: AnyObject)
    {
        if longPress.state == .began
        {   //activity indicator is loaded
            activityIndicator.startAnimating()
            // coordinates of a point the user touched on the map
            let tpt = sender.location(in: self.map)
            let coordinates = self.map.convert(tpt, toCoordinateFrom: self.map)
            let anotation = MKPointAnnotation()
            anotation.coordinate = coordinates
            Properties.latitude = coordinates.latitude
            Properties.longitude = coordinates.longitude
            let endetail = NSEntityDescription.entity(forEntityName: "City", in: self.vc)
            let city = City(entity: endetail!, insertInto: self.vc)
            city.latitude = coordinates.latitude
            city.longitude = coordinates.longitude
            self.app.saveContext()
            self.map.addAnnotation(anotation)
            
            //invoking the method from Networking class
            invoking.AccessingWeatherWRTMap(latitude: Properties.latitude, longitude: Properties.longitude, completionHandlerForgetWeatherUsingMap: { (sucess, error) in
                
                DispatchQueue.main.sync {
                    //stops animating
                    self.activityIndicator.stopAnimating()
                }
                //if internet is on ,the pin can be added
                if sucess
                {
                    //debug print
                    print("internet is on")
    
                    
                }//if success closed
                    
                    //if the internet is off just the alert is shown
                else {
                     performUIUpdatesOnMain
                      {
                         self.app.saveContext()
                        //displaying alert when no connection is there
                         self.displayAlert(title: "cannot retrieve weather details", message: "plz check your connection")
                       }//perform closed
                    
                }//else closed
            })//instance closed
            
        }//main if function closed
        
    }//function closed
    
    //method for setting the map
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lat = (view.annotation?.coordinate.latitude)!
        let lon = (view.annotation?.coordinate.longitude)!
        Properties.latitude = view.annotation?.coordinate.latitude
        Properties.longitude = view.annotation?.coordinate.longitude
        let instantcontroller = self.storyboard?.instantiateViewController(withIdentifier: "weatherViewController") as! WeatherViewController
        let information:[City]!
        do{
            information = try self.vc.fetch(self.fetchr)
        }
        catch{
            
            print("RETRIEVAL OF DATA IS IMPOSSIBLE")
            return
        }
        
        for value in information
        {
            if value.latitude == Properties.latitude && value.longitude == Properties.longitude && value.humidity == 0
            {
                //activity indicator is added
                activityIndicator.startAnimating()
                //invoking the method from Networking class
                self.invoking.AccessingWeatherWRTMap(latitude: lat,longitude: lon,completionHandlerForgetWeatherUsingMap: { (sucess, error) in
                    DispatchQueue.main.sync
                        {
                        //activity indicator is stopped
                        self.activityIndicator.stopAnimating()
                        }
                    
                    if sucess
                    {
                        
                        instantcontroller.City = information[information.index(of: value)!]
                        performUIUpdatesOnMain
                            {
                                self.present(instantcontroller, animated: true, completion: nil)
                            }
                    }//if sucess
                    else
                    {
                        performUIUpdatesOnMain
                            {
                                //displaying alert when internet is off
                                self.displayAlert(title: "cannot retrieve weather details ", message: "plz check your connection")
                             }
                    }//else
                })
            }//if value
            else if value.latitude == Properties.latitude && value.longitude == Properties.longitude
            {
                instantcontroller.City = information[information.index(of: value)!]
                performUIUpdatesOnMain
                    {
                      self.present(instantcontroller, animated: true, completion: nil)
                     }
            }//else if
        }
    }
}
    /**Code Review SUGGESTION
     You can create an extension of UIViewController and put this method there and call it whenever you need it from any class that inherits from UIViewController.**/
    
    extension UIViewController
    {

    //taken from
    //http://stackoverflow.com/questions/26228729/ios-8-uialertview-uialertcontroller-not-showing-text-or-buttons
    //method for displaying alerts if occurs
    func displayAlert(title: String, message: String)
    {
        let alert = UIAlertController()
        alert.title = title
        alert.message = message
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            
            action in
            alert.dismiss(animated: true, completion: nil)
            
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
