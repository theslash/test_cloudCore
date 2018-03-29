//
//  Person+CoreDataProperties.swift
//  coreDataCacao1987
//
//  Created by Rudi Krämer on 29.03.18.
//  Copyright © 2018 Rudi Krämer. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}
