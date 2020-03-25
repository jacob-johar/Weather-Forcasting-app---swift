//
//  Properties.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import UIKit
//structure for declaring the necessary properties
struct Properties
{
    static var latitude: Double!
    static var longitude: Double!
    static var cityName: String!
    static var weatherToday: String!
    static var watherDescription: String!
    static var temperature: Double!
    static var pressure: Double!
    static var humidity: Double!
    static var minTemperature: Double!
    static var maxTemperature: Double!
    
    //api key received from http://openweathermap.org/api
    static var apiID = "764e3acde8c694316738435c92b35bbe"
}

