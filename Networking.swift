//
//  Networking.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Networking
{
    //save to core data
    let vc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       //create fetch request
    var fetchr : NSFetchRequest<City> = City.fetchRequest()
    var app = (UIApplication.shared.delegate as! AppDelegate)
    
    
    func AccessingWeatherWRTMap(latitude: Double, longitude: Double,completionHandlerForgetWeatherUsingMap: @escaping (_ sucess:Bool, _ error: String) -> Void)
    {
        //given by http://openweathermap.org/api
        //api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=764e3acde8c694316738435c92b35bbe
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(Properties.apiID)"
         //Debug Print for URL
        print("\(urlString) ")
        
        //Make it URL
        let url = URL(string: urlString)!
        
         //Build the URLRequest
        let request = URLRequest(url: url)
        
        //Initiating Task URL request
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else
            {
                print("ERROR:RETRIVING WEATHER DATA")
                return completionHandlerForgetWeatherUsingMap(false, "\(error!.localizedDescription)")
            }

            guard let data = data else
            {
                print("NO DATA IS AVAILABLE")
                //addition of comletion handler as per the review
                return completionHandlerForgetWeatherUsingMap(false, "")
            }
            
            // Parse the data
            var parsedResult: NSDictionary!
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            }
            catch
            {
                print("UNABLE TO PARSE")
                return
            }
            guard let cityName = parsedResult["name"] as? String else
            {
                print("CANNOT RETRIEVE cityName")
                return
            }
            guard let mainData = parsedResult["main"] as? NSDictionary else
            {
                print("CANNOT RETRIEVE WEATHER INFORMATION")
                return
            }
            guard let currentTemp = mainData["temp"] as? Double else
            {
                print("CANNOT RETRIEVE CURRENT TEMPERATURE")
                return
            }
            guard let pressure = mainData["pressure"] as? Double else
            {
                print("CANNOT RETRIEVE PRESSURE")
                return
            }
            guard let humidity = mainData["humidity"] as? Double else
            {
                print("CANNOT RETRIEVE HUMIDITY")
                return
            }
            guard let minTemp = mainData["temp_min"] as? Double else
            {
                print("CANNOT RETRIEVE MIN-TEMPERATURE")
                return
            }
            guard let maxTemp = mainData["temp_max"] as? Double else
            {
                print("CANNOT RETRIEVE MAX-TEMPERATURE")
                return
            }
            guard let weather = parsedResult["weather"] as? [[String: Any]] else
            {
                print("CANNOT RETRIEVE WEATHER INFOTMATION")
                return
            }
            
            //Declaration of necessary variables
            var weathercondition: String!
            var weatherinformation: String!
            
            for value in weather
            {
                guard let condition = value["main"] as? String else
                {
                    print("CANNOT RETRIEVE ANY DATA")
                    return
                }
                weathercondition = condition
                guard let info = value["description"] as? String else
                {
                    print("CANNOT RETRIEVE WEATHER DESCRIPTION")
                    return
                }
                weatherinformation = info
            }
            guard let sys = parsedResult["sys"] as? NSDictionary else
            {
                print("CANNOT RETRIEVE SYSTEM INFORMATION")
                return
            }
            guard let country = sys["country"] as? String else
            {
                print("CANNOT RETRIEVE COUNTRY INFORMATION")
                return
            }
            Properties.cityName = "\(cityName),\(country)"
            Properties.humidity = humidity
            Properties.maxTemperature = maxTemp
            Properties.minTemperature = minTemp
            Properties.pressure = pressure
            Properties.temperature = currentTemp
            Properties.watherDescription = weatherinformation
            Properties.weatherToday = weathercondition
            self.SavingData(latitude: latitude, longitude: longitude)
            return completionHandlerForgetWeatherUsingMap(true, "")
        }
        task.resume()
    }
    
    func SavingData(latitude: Double, longitude: Double)
    {
        let information:[City]!
        do{
            information = try self.vc.fetch(self.fetchr)
        }
        catch{
            
            print("CANNOT RETRIEVE ANY DATA")
            return
        }
        
        for value in information
        {
            if value.latitude == latitude && value.longitude == longitude
            {
                value.cityName = Properties.cityName
                value.humidity = Properties.humidity
                value.max_temp = Properties.maxTemperature
                value.min_temp = Properties.minTemperature
                value.pressure = Properties.pressure
                value.temperature = Properties.temperature
                value.weather = Properties.weatherToday
                value.weatherDescription = Properties.watherDescription
                self.app.saveContext()
            }
        }
   
     }
   
}


