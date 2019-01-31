//
//  SessionListViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/18.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import AVFoundation
//import BusinessLogicLayer
//import PersistenceLayer


class SessionListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var currentClock: UILabel!
    
    var listData = NSMutableArray()
    var dateData = NSMutableArray()
    var bl = NoteBL()
    var currentHour: String!
    var currentMinute: String!
    var startHourMinute: String!
    var startYearMonthDay: String!
    var toHourMinute: String!
    var startHour: String!
    var startMinute: String!
    var toHour: String!
    var toMinute: String!
    var currentHourMinute: String!
    var sessionPer: String!
    var sessionProgress: Float!
    var sessionTime: String!
    var sessionDiv: String!
    var nowTime: Int!
    var nowDay: Int!
    var currentsession: String!
    let systemSoundID: SystemSoundID = 1005
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.listData = bl.findAll()
        
        findDateList()
        self.tableView.reloadData()
        
        setClock()
        nowTime = Int(currentHourMinute)
    }
    
    func setClock(){
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var monthS: String!
        var dayS: String!
        
        if(month < 10){
            monthS = "0" + String(month)
        }else{
            monthS = String(month)
        }
        
        if(day < 10){
            dayS = "0" + String(day)
        }else{
            dayS = String(day)
        }
        
        let yearS = String(year)

        nowDay = Int(yearS + monthS + dayS)
        
        if(hour < 10) {
            currentHour = "0" + String(hour)
        } else{
            currentHour = String(hour)
        }
        
        if(minute < 10) {
            currentMinute = "0" + String(minute)
        } else{
            currentMinute = String(minute)
        }
        
        self.currentClock.text = currentHour + " : " + currentMinute
        self.currentHourMinute = currentHour + currentMinute
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calendar.delegate = self
        self.calendar.select(Date())
        
        
        self.calendar.scope = .month
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setClock()
        nowTime = Int(currentHourMinute)
        
        self.listData = bl.findAll()
        
        findDateList()
        
        self.tableView.reloadData()
        
     }
    
    
    deinit {
        //print("\(#function)")
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        findDateList()
        
        self.tableView.reloadData()

    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dateData.count
    }
 
    
    func findDateList(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let cdate = formatter.string(from: self.calendar.selectedDate!)
        let start = cdate.startIndex
        let end = cdate.index(cdate.startIndex, offsetBy: 10)
        let range = start..<end
        
        self.dateData.removeAllObjects()
        
        
        for i in 0..<self.listData.count {
            
            let note = self.listData[i] as! Notes
            let nstart = note.start.startIndex
            let nend = note.start.index(note.start.startIndex, offsetBy: 10)
            let nrange = nstart..<nend
            
            if(note.start.substring(with: nrange) == cdate.substring(with: range)){
                dateData.add(listData.object(at: i) as! Notes)
            }
        }
        
    }
    
    func reloadView(_ notification : Notification) {
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "slistcell", for: indexPath) as! SlistCell
        
        let note = self.dateData[indexPath.row] as! Notes
        
        let yearstart = note.start.index(note.start.startIndex, offsetBy: 0)
        let yearend = note.start.index(note.start.startIndex, offsetBy: 4)
        let yearrange = yearstart..<yearend
        
        let monthstart = note.start.index(note.start.startIndex, offsetBy: 5)
        let monthend = note.start.index(note.start.startIndex, offsetBy: 7)
        let monthrange = monthstart..<monthend
        
        let daystart = note.start.index(note.start.startIndex, offsetBy: 8)
        let dayend = note.start.index(note.start.startIndex, offsetBy: 10)
        let dayrange = daystart..<dayend
        
        let mstart = note.start.index(note.start.startIndex, offsetBy: 11)
        let mend = note.start.index(note.start.startIndex, offsetBy: 16)
        let mrange = mstart..<mend
        
        let mhstart = note.start.index(note.start.startIndex, offsetBy: 11)
        let mhend = note.start.index(note.start.startIndex, offsetBy: 13)
        let mhrange = mhstart..<mhend
        
        let mmstart = note.start.index(note.start.startIndex, offsetBy: 14)
        let mmend = note.start.index(note.start.startIndex, offsetBy: 16)
        let mmrange = mmstart..<mmend
        
        let qstart = note.to.index(note.to.startIndex, offsetBy: 11)
        let qend = note.to.index(note.to.startIndex, offsetBy: 16)
        let qrange = qstart..<qend
        
        let qhstart = note.to.index(note.to.startIndex, offsetBy: 11)
        let qhend = note.to.index(note.to.startIndex, offsetBy: 13)
        let qhrange = qhstart..<qhend
        
        let qmstart = note.to.index(note.to.startIndex, offsetBy: 14)
        let qmend = note.to.index(note.to.startIndex, offsetBy: 16)
        let qmrange = qmstart..<qmend
        
        startYearMonthDay = note.start.substring(with: yearrange) as String! + note.start.substring(with: monthrange) as String! + note.start.substring(with: dayrange) as String!

        startHourMinute = note.start.substring(with: mhrange) + note.start.substring(with: mmrange)
        toHourMinute = note.to.substring(with: qhrange) + note.to.substring(with: qmrange)
        startHour = note.start.substring(with: mhrange)
        startMinute = note.start.substring(with: mmrange)
        toHour = note.to.substring(with: qhrange)
        toMinute = note.to.substring(with: qmrange)
        
        cell.taskItem.text = note.content
        cell.startTime.text = note.start.substring(with: mrange)
        cell.toTime.text = note.to.substring(with: qrange)
        
        if(nowDay < Int(startYearMonthDay)!){
            sessionDiv = "0" + "/" + note.session
            sessionTime = "Not yet!"
            sessionPer = "0%"
            currentsession = "Session:0"
            sessionProgress = 0.0
        }else if(nowDay > Int(startYearMonthDay)!){
            sessionDiv = note.session + "/" + note.session
            sessionTime = "Complete"
            sessionPer = "100%"
            currentsession = "All"
            sessionProgress = 1.0
        } else{
            
        
            if(Int(toHour)! < Int(startHour)!){
                toHourMinute = String(Int(note.to.substring(with: qhrange))! + 24) + note.to.substring(with: qmrange)
                nowTime = Int(String(Int(currentHour)! + 24) + currentMinute)
            }
            if(nowTime! >= Int(toHourMinute)!){
                sessionDiv = note.session + "/" + note.session
                sessionTime = "Complete"
                sessionPer = "100%"
                currentsession = "All"
                sessionProgress = 1.0
            } else if(nowTime! < Int(startHourMinute)!){
                sessionDiv = "0" + "/" + note.session
                sessionTime = "Not Start Yet"
                sessionPer = "0%"
                currentsession = "0"
                sessionProgress = 0.0
            } else{
                let sessionnumber = getSession(content: note.content, session: note.session, sessionstart: note.sessionstart, sessionend: note.sessionend)
                if(sessionnumber == 0) {
                    //print("The session is not valid")
                    cell.partialSeesion.text = "N/A"
                    cell.sessionTime.text = "N/A"
                    cell.currentSession.text = "N/A"
                    cell.currentPercentage.text = "N/A"
                    cell.currentProgress.progress = 0.0
                    return cell
                }
            }
        }
        
        cell.partialSeesion.text = sessionDiv
        cell.sessionTime.text = sessionTime
        cell.currentPercentage.text = sessionPer
        cell.currentSession.text = currentsession
        cell.currentProgress.progress = sessionProgress!
        
        return cell
    }
    
    func getSession(content:String, session:String, sessionstart: String, sessionend: String) -> Int{
        
        //let nowTime = Int(currentHourMinute)
        let sessionNumber = Int(session)
        //var wholeSessionStartHour: String!
        //var wholeSessionStartMinute: String!
        
       
        for i in (1...sessionNumber!){
            
            let j = (i - 1) * 5 + 1
            let k = j + 4
            let m = j + 2
            
            // for total hour+minute String (e.g. 1643 means 4:43 pm)
            let sessionSbegin = sessionstart.index(sessionstart.startIndex, offsetBy: j)
            let sessionSstop = sessionstart.index(sessionstart.startIndex, offsetBy: k)
            let sessionSrange = sessionSbegin..<sessionSstop

            let sessionSComp = sessionstart.substring(with: sessionSrange)
            
            let sessionEbegin = sessionend.index(sessionend.startIndex, offsetBy: j)
            let sessionEstop = sessionend.index(sessionend.startIndex, offsetBy: k)
            let sessionErange = sessionEbegin..<sessionEstop
            
            let sessionEComp = sessionend.substring(with: sessionErange)
            
            // for hour and minute String (e.g. 1643 hour means 16; minute means 43)
            let sessionShbegin = sessionstart.index(sessionstart.startIndex, offsetBy: j)
            let sessionShstop = sessionstart.index(sessionstart.startIndex, offsetBy: m)
            let sessionShrange = sessionShbegin..<sessionShstop
            
            let sessionShComp = sessionstart.substring(with: sessionShrange)
            
            let sessionSmbegin = sessionstart.index(sessionstart.startIndex, offsetBy: m)
            let sessionSmstop = sessionstart.index(sessionstart.startIndex, offsetBy: k)
            let sessionSmrange = sessionSmbegin..<sessionSmstop
            
            let sessionSmComp = sessionstart.substring(with: sessionSmrange)
 
            if(nowTime! >= Int(sessionSComp)! && nowTime! <= Int(sessionEComp)!){
                sessionDiv = String(i) + "/" + session
                sessionTime = sessionSComp + "~" + sessionEComp
                let hourgap = Int(currentHour)! - Int(startHour)!
                let minutegap = Int(currentMinute)! - Int(startMinute)!
                let totalhourgap = Int(toHour)! - Int(startHour)!
                let totalminutegap = Int(toMinute)! - Int(startMinute)!
                let totalgap = 60 * hourgap + minutegap
                let totalduration = 60 * totalhourgap + totalminutegap
                let digitalPer = 100 * (Float(totalgap)/Float(totalduration))
                sessionProgress = Float(totalgap)/Float(totalduration)
                sessionPer = String(format: "%.1f",digitalPer) + "%"
                currentsession = "Session#" + String(i)
                return i
            } else if(nowTime! > Int(sessionEComp)! && nowTime! < (Int(sessionEComp)! + 5)){
                sessionDiv = String(i) + "/" + session
                sessionTime = sessionSComp + "~" + sessionEComp
                let hourgap = Int(currentHour)! - Int(startHour)!
                let minutegap = Int(currentMinute)! - Int(startMinute)!
                let totalhourgap = Int(toHour)! - Int(startHour)!
                let totalminutegap = Int(toMinute)! - Int(startMinute)!
                let totalgap = 60 * hourgap + minutegap
                let totalduration = 60 * totalhourgap + totalminutegap
                let digitalPer = 100 * (Float(totalgap)/Float(totalduration))
                sessionProgress = Float(totalgap)/Float(totalduration)
                sessionPer = String(digitalPer) + "%"
                currentsession = "Break#" + String(i)
                showSessionStartAlert(index:i,content:content)
                return i
            } else{
                //print("nowTimw: " + String(nowTime) + " sessionSComp: "  + sessionSComp + " sessionEComp: " + sessionEComp)
            }
        }
        
        return 0
    }
    
    func showSessionStartAlert(index: Int, content:String) {
        
        // Play Alert Sound
        AudioServicesPlaySystemSound (systemSoundID)
        
        // create the alert
        let alert = UIAlertController(title: "Session Start Alert", message: "Your task (" + content + ") is going to start with the session # " + String(index+1), preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //if indexPath.section == 0 {
        //let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
        //self.calendar.setScope(scope, animated: true)
        self.calendar.setScope(.month, animated: true)
        //self.animationSwitch.isOn)
        //}
    }
}
