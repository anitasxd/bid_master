//
//  Note.swift
//  MyNotes
//
//

import Foundation

public class Notes: NSObject, NSCoding {

    public var date: NSDate
    public var content: String
    public var completed: Bool
    public var start: String
    public var to: String
    public var session: String
    public var sessionstart: String
    public var sessionend: String

    public init(date: NSDate, content: String, checked: Bool, start: String, to: String, session: String, sessionstart: String, sessionend: String) {
        self.date = date
        self.content = content
        self.completed = checked
        self.start = start
        self.to = to
        self.session = session
        self.sessionstart = sessionstart
        self.sessionend = sessionend
    }

    override public init() {
        self.date = NSDate()
        self.content = ""
        self.completed = false
        self.start = ":"
        self.to = ":"
        self.session = "1"
        self.sessionstart = ""
        self.sessionend = ""
    }

 
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(completed, forKey: "completed")
        aCoder.encode(start, forKey: "start")
        aCoder.encode(to, forKey: "to")
        aCoder.encode(session, forKey: "session")
        aCoder.encode(sessionstart, forKey: "sessionstart")
        aCoder.encode(sessionend, forKey: "sessionend")
    }

    public required init(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: "date") as! NSDate
        self.content = aDecoder.decodeObject(forKey: "content") as! String
        self.completed = aDecoder.decodeObject(forKey: "completed") as! Bool
        self.start = aDecoder.decodeObject(forKey: "start") as! String
        self.to = aDecoder.decodeObject(forKey: "to") as! String
        self.session = aDecoder.decodeObject(forKey: "session") as! String
        self.sessionstart = aDecoder.decodeObject(forKey: "sessionstart") as! String
        self.sessionend = aDecoder.decodeObject(forKey: "sessionend") as! String
    }
}
