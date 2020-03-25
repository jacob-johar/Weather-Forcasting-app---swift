//
//  LocationViewController.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
class LocationSelectorViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate
{
    
    //IB OUTLETS
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    //save to core data
    let vc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //create fetch request
    var fetchr : NSFetchRequest<City> = City.fetchRequest()
    
    var app = (UIApplication.shared.delegate as! AppDelegate)
    
    //creating instance of class Networking()
    let invoking = Networking()
    
    override func viewDidLoad() {
        activityView.isHidden = true
    }
    
    @IBAction func FindLocation(_ sender: AnyObject) {
        activityView.isHidden = false
        searchButton.isEnabled = false
        searchTextField.isEnabled = false
        cancel.isEnabled = false
        getLocation { (sucess) in
            if sucess
            {
                 //invokig the method of Networking class
                self.invoking.AccessingWeatherWRTMap(latitude: Properties.latitude,longitude: Properties.longitude,completionHandlerForgetWeatherUsingMap: { (sucess, error) in
                    if sucess
                    {
                        performUIUpdatesOnMain {
                            self.activityView.isHidden = true
                            self.searchButton.isEnabled = true
                            self.searchTextField.isEnabled = true
                            self.cancel.isEnabled = true
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        self.activityView.isHidden = true
                        self.searchButton.isEnabled = true
                        self.searchTextField.isEnabled = true
                        self.cancel.isEnabled = true
                        //displaying alert when internet is off
                        self.displayAlert(title: "cannot retrieve weather details", message: "plz check your connection")
                    }
                })
            }
            else
            {
                performUIUpdatesOnMain {
                    self.activityView.isHidden = true
                    self.searchButton.isEnabled = true
                    self.searchTextField.isEnabled = true
                    self.cancel.isEnabled = true
                    
                }
            }
        }
    }
       func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getLocation(completionHandlerForGeoLocation: @escaping(_ sucess: Bool) -> Void )
    {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.searchTextField.text!, completionHandler: {(lanmarks: [CLPlacemark]?, error: Error?) in
            
            guard error == nil else
            {
                
                let error = ((error?.localizedDescription)!)
                print(error)
                if error == "The operation couldn’t be completed. (kCLErrorDomain error 2.)"
                {
                    print(error)
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "UNABLE TO CONNECT", message: "PLZ CHECK YOUR CONNECTION")
                    }
                    return completionHandlerForGeoLocation(false)
                }
                else if error == "The operation couldn’t be completed. (kCLErrorDomain error 8.)"
                {
                    performUIUpdatesOnMain {
                        //displaying alert when area is not available
                        self.displayAlert(title: "NOT AVAILABLE ", message: "TRY OTHER ONE")
                    }
                    return completionHandlerForGeoLocation(false)
                    
                }
                return completionHandlerForGeoLocation(false)
            }
            guard let lanmark = lanmarks else
            {
                print("NOT AVAILABLE")
                return
            }
            guard let latitude = lanmark[0].location?.coordinate.latitude else
            {
                
                print("UNABLE TO COPY")
                return
            }
            guard let longitude = lanmark[0].location?.coordinate.longitude else
            {
                
                print("UNABLE TO COPY")
                return
            }
            Properties.latitude = latitude
            Properties.longitude = longitude
            let endetail = NSEntityDescription.entity(forEntityName: "City", in: self.vc)
            let city = City(entity: endetail!, insertInto: self.vc)
            city.latitude = latitude
            city.longitude = longitude
            self.app.saveContext()
            completionHandlerForGeoLocation(true)
            
        })
    }
    

    
}
