//
//  Person+CoreDataProperties.swift
//  ToDo
//
//  Created by alfian0 on 12/16/17.
//  Copyright © 2017 alfian0. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var assigned: NSSet?

}

// MARK: Generated accessors for assigned
extension Person {

    @objc(addAssignedObject:)
    @NSManaged public func addToAssigned(_ value: ToDo)

    @objc(removeAssignedObject:)
    @NSManaged public func removeFromAssigned(_ value: ToDo)

    @objc(addAssigned:)
    @NSManaged public func addToAssigned(_ values: NSSet)

    @objc(removeAssigned:)
    @NSManaged public func removeFromAssigned(_ values: NSSet)

}
