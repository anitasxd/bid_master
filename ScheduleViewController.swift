//
//  ScheduleViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/1.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import BusinessLogicLayer
import PersistenceLayer

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var listData = NSMutableArray()
    var dateData = NSMutableArray()
    var bl = NoteBL()
    var cellnum = 0
    
     //@IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calendar.delegate = self
        self.calendar.select(Date())
        
 
        self.calendar.scope = .month
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.listData = bl.findAll()
        
        findDateList()
        
        self.tableView.reloadData()
        
        /*
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadView(_:)),
                                               name: NSNotification.Name(rawValue: "reloadViewNotification"),
                                               object: nil)
        */
        
    }
    
    

    
    deinit {
        //print("\(#function)")
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
 
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
         if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        findDateList()
        
        self.tableView.reloadData()
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadViewNotification"), object: nil, userInfo: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sessionDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let detailVC = segue.destination as! SessionViewController
 
                detailVC.taskDescribe = (self.dateData[indexPath.row] as! Notes).content
                
                detailVC.timeBlock = (self.dateData[indexPath.row] as! Notes).start + " ~ " + (self.dateData[indexPath.row] as! Notes).to
                
                detailVC.date1 = (self.dateData[indexPath.row] as! Notes).start
                
                detailVC.date2 = (self.dateData[indexPath.row] as! Notes).to
                
                detailVC.date = (self.dateData[indexPath.row] as! Notes).date as Date!

            }
        }
    }

    
    func reloadView(_ notification : Notification) {
        //let resList = notification.object as! NSMutableArray
        //self.listData = resList
        self.tableView.reloadData()
    }

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scell", for: indexPath) as! scheduleCell
        
        let note = self.dateData[indexPath.row] as! Notes
        
        let mstart = note.start.index(note.start.startIndex, offsetBy: 11)
        let mend = note.start.index(note.start.startIndex, offsetBy: 16)
        let mrange = mstart..<mend
        
        let qstart = note.to.index(note.to.startIndex, offsetBy: 11)
        let qend = note.to.index(note.to.startIndex, offsetBy: 16)
        let qrange = qstart..<qend
        
        cell.taskItem.text = note.content
        cell.startTime.text = note.start.substring(with: mrange)
        cell.toTime.text = note.to.substring(with: qrange)
        
        return cell
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
