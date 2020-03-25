//
//  TableViewController.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate
{
    //IB OUTLETS
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    //save to core data
    let vc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //create fetch request
    var fetchr : NSFetchRequest<City> = City.fetchRequest()
    var app = (UIApplication.shared.delegate as! AppDelegate)
     //create fetch request controller
    var fetchcontrol: NSFetchedResultsController<City>!
    
    var information: [City]!
    
    override func viewDidLoad() {
        fetchcontrol = fetchResultsController()
        information = fetchcontrol.fetchedObjects
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchcontrol = fetchResultsController()
        information = fetchcontrol.fetchedObjects
        tableView.reloadData()
    }
    //method for getting the number of data available
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return information.count
        
    }
    //method for viewing the data in tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //newly added
        var displayCityName = "Loading..."
        var displayWeather = "Loading..."
        let displayTemperature = information[indexPath.row].temperature
        
        if let cityName = information[indexPath.row].cityName {
            displayCityName = cityName
        }
        if let weather = information[indexPath.row].weather {
            displayWeather = weather
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = displayCityName
        cell?.detailTextLabel?.text = "WEATHER: \(displayWeather) \t TEMPERATURE: \(displayTemperature)°C"
        return cell!
    }
    
    // Fetched Results Controller
    func fetchResultsController() -> NSFetchedResultsController<City>
    {
        // Sort the fetch request by cityName, ascending.
        self.fetchr.sortDescriptors = [NSSortDescriptor(key: "cityName", ascending: true)]
         // Create fetched results controller with the new fetch request.
        let fetchcontrol = NSFetchedResultsController(fetchRequest: self.fetchr, managedObjectContext: self.vc, sectionNameKeyPath: nil, cacheName: nil)
        fetchcontrol.delegate = self
        do
        {
            
            try fetchcontrol.performFetch()
        }
        catch
        {
            print("CANNOT FETCH OBJECTS")
            return fetchcontrol
        }
        
        return fetchcontrol
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instantcontroller = self.storyboard?.instantiateViewController(withIdentifier: "weatherViewController") as! WeatherViewController
        instantcontroller.City = information[indexPath.row]
        performUIUpdatesOnMain {
            self.present(instantcontroller, animated: true, completion: nil)
        }
    }
    //method which corressponds to deletion of particular cell from the list view
    @IBAction func longPress(_ sender: AnyObject) {
        if longPress.state == .began
        {
            let pt = sender.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: pt)
            let information = self.information[(indexPath?.row)!]
            let infoArray:[City]!
            do{
                infoArray = try self.vc.fetch(self.fetchr)
            }
            catch{
                
                print("CANNOT RETRIEVE DATA")
                return
            }
            
            for value in infoArray
            {
                if value == information
                {
                    self.vc.delete(value)
                    self.app.saveContext()
                }
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete
        {
            information = fetchcontrol.fetchedObjects
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
        if type == .update
        {
            information = fetchcontrol.fetchedObjects
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func addLocation(_ sender: AnyObject) {
        let instantcontroller = self.storyboard?.instantiateViewController(withIdentifier: "locationViewController") as! LocationSelectorViewController
        performUIUpdatesOnMain {
            self.present(instantcontroller, animated: true, completion: nil)
        }
    }
    //method for refreshing the screen
    @IBAction func refresh(_ sender: AnyObject) {
        
               
        let information = fetchcontrol.fetchedObjects
       
        for value in information!
        {
            Properties.latitude = value.latitude
            Properties.longitude = value.longitude
            
            //creating instance of class Networking()
            let instance = Networking()
            
             //invokig the method of Networking class
            instance.AccessingWeatherWRTMap(latitude: value.latitude,longitude: value.longitude,completionHandlerForgetWeatherUsingMap: { (sucess, error) in
                
                if sucess
                {
                    
                    // Debug Prints
                    print("data is refreshed")
                }
                else{
                    performUIUpdatesOnMain {
                        //displaying alert when no connection is there
                        self.displayAlert(title: "cannot retrieve weather detils", message: "plz check your connection")
                    }
                }
            })
        }
        
    }
    

    
}
