//
//  NoteBL.swift
//  MyNotes
//
//

import Foundation
//import PersistenceLayer

open class NoteBL {
    
    public init() {
    }
    
    open func create(_ model: Notes) -> NSMutableArray {
        let dao:NoteDAO = NoteDAO.sharedInstance
        dao.create(model)
        return dao.findAll()!
    }
    
    open func modify(_ model: Notes) -> NSMutableArray {
        let dao:NoteDAO = NoteDAO.sharedInstance
        dao.modify(model)
        return dao.findAll()!
    }

    open func remove(_ model: Notes) -> NSMutableArray {
        let dao:NoteDAO = NoteDAO.sharedInstance
        dao.remove(model)
        return dao.findAll()!
    }
    
    open func findAll() -> NSMutableArray {
        let dao:NoteDAO = NoteDAO.sharedInstance
        return dao.findAll()!
    }
    
    open func findById(_ model: Notes) -> Notes? {
        let dao:NoteDAO = NoteDAO.sharedInstance
        if(dao.findById(model) != nil){
            return dao.findById(model)!
        } else {
            return model
        }
    }
}
