//
//  LocationEntity+CoreDataProperties.swift
//  Weather
//
//  Created by Tomas Sanni on 6/27/23.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var timeAdded: Date?
    @NSManaged public var currentDate: String?
    @NSManaged public var temperature: String?
    @NSManaged public var sfSymbol: String?
    @NSManaged public var timezone: Int16

}

extension LocationEntity : Identifiable {

}
