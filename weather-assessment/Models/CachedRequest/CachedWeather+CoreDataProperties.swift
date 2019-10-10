//
//  CachedWeather+CoreDataProperties.swift
//  
//
//  Created by Eugenio Baglieri on 06/10/2019.
//
//

import Foundation
import CoreData


extension CachedWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedWeather> {
        return NSFetchRequest<CachedWeather>(entityName: "CachedWeather")
    }

    @NSManaged public var expiringTime: TimeInterval
    @NSManaged public var city: String?
    @NSManaged public var data: Data?

}
