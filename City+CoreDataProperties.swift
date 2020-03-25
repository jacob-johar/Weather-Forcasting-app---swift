//
//  City+CoreDataProperties.swift
//  WeatherForcasting
//
//  Created by jacob n johar on 02/01/17.
//  Copyright © 2017 jacob  johar. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var max_temp: Double
    @NSManaged public var min_temp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var temperature: Double
    @NSManaged public var weather: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var cityName: String?
    @NSManaged public var humidity: Double

}
