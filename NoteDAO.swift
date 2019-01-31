//
//  NoteDAO.swift
//  MyNotes
//
//
//

import Foundation
import CoreData

public class NoteDAO : CoreDataDAO {
    

    private var dateFormatter = DateFormatter()
    
    public static let sharedInstance: NoteDAO = {
        let instance = NoteDAO()
        
        instance.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return instance
    }()
    

    public func create(_ model: Notes) -> Int {
        
        let context = persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Notes", into:context) as! NotesManagedObject
        
        note.date = model.date
        note.content = model.content
        note.completed = model.completed
        note.start = model.start
        note.to = model.to
        note.session = model.session
        note.sessionstart = model.sessionstart
        note.sessionend = model.sessionend
        
  
        self.saveContext()
        
        return 0
    }
    
    public func remove(_ model: Notes) -> Int {
        
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "date = %@", model.date)
        
        do {
            let listData = try context.fetch(fetchRequest)
            if listData.count > 0 {
                let note = listData[0] as! NSManagedObject
                context.delete(note)
                self.saveContext()
            }
        } catch {
            NSLog("Fail to remove data")
        }
        return 0
    }
    
    //修改Note方法
    public func modify(_ model: Notes) -> Int {
        
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "date = %@", model.date)
        
        do {
            let listData = try context.fetch(fetchRequest)
            if listData.count > 0 {
                let note = listData[0] as! NotesManagedObject
                note.setValue(model.content, forKey: "content")
                note.content = model.content
                //print("model completed -" + String(model.completed))
                note.setValue(model.completed, forKey: "completed")
                note.completed = model.completed
                note.setValue(model.start, forKey: "start")
                note.start = model.start
                note.setValue(model.to, forKey: "to")
                note.to = model.to
                note.setValue(model.session, forKey: "session")
                note.session = model.session
                note.setValue(model.sessionstart, forKey: "sessionstart")
                note.sessionstart = model.sessionstart
                note.setValue(model.sessionend, forKey: "sessionend")
                note.sessionend = model.sessionend
                

                self.saveContext()
            }
        } catch {
            NSLog("Fail to modify data")
        }
        return 0
    }
    

    public func findAll() -> NSMutableArray? {
        
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key:"date", ascending:true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let listData = try context.fetch(fetchRequest)
            let resListData = NSMutableArray()
            
            if listData.count > 0 {
                
                for item in listData {
                    let mo = item as! NotesManagedObject
                    let note = Notes(date: mo.date, content: mo.content, checked: mo.completed, start: mo.start, to: mo.to, session: mo.session, sessionstart: mo.sessionstart, sessionend: mo.sessionend)
                    resListData.add(note)
                }
            }
            return resListData
        } catch {
            NSLog("Fail to search data")
            return nil
        }
    }
    

    public func findById(_ model: Notes) -> Notes? {
        
        let context = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "date = %@", model.date)
        
        do {
            let listData = try context.fetch(fetchRequest)
            
            if listData.count > 0 {
                let mo = listData[0] as! NotesManagedObject
                let note = Notes(date: mo.date, content: mo.content, checked: mo.completed, start: mo.start, to: mo.to, session: mo.session, sessionstart: mo.sessionstart, sessionend: mo.sessionend)
                return note
            }
        } catch {
            NSLog("Fail to search data")
        }
        return nil
    }
    
}
