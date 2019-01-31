//
//  CoreDataDAO.swift
//  PersistenceLayer
//
//
//


import Foundation
import CoreData

open class CoreDataDAO: NSObject {

   
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BID")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //print("Persistence Storage error：", error.localizedDescription)
            }
        })
        return container
    }()



    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                //print("data storage eeeor：", nserror.localizedDescription)

            }
        }
    }
}
