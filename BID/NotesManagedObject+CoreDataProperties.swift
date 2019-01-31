//
//  NotesManagedObject+CoreDataProperties.swift
//  PersistenceLayer
//
//  
//

import Foundation
import CoreData

extension NotesManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesManagedObject> {
        return NSFetchRequest<NotesManagedObject>(entityName: "Notes");
    }

    @NSManaged public var date: NSDate
    @NSManaged public var content: String
    @NSManaged public var completed: Bool
    @NSManaged public var start: String
    @NSManaged public var to: String
    @NSManaged public var session: String
    @NSManaged public var sessionstart: String
    @NSManaged public var sessionend: String

}
