//
//  SessionViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/14.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
//import BusinessLogicLayer
//import PersistenceLayer


class SessionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate {

    @IBOutlet weak var sessionTask: UILabel!
    @IBOutlet weak var sessionTime: UILabel!
    @IBOutlet weak var sessionPicker: UIPickerView!
    @IBOutlet weak var sessionTable: UITableView!
  
    var listData = NSMutableArray()
    //var dateData = NSMutableArray()
    var bl = NoteBL()

    
    var timeTextField: UITextField!
    
    var pickerDataSource = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
    
    var retArray:NSMutableArray = []
    var timeArray:NSMutableArray = []
    var time2Array:NSMutableArray = []
    
    //var retArray2:NSMutableArray = []
    
    //var minuteDataSource = ["1", "2", "3", "4", "5"];
    
    var numSession = 1
    
    var taskDescribe: String!
    var timeBlock: String!
    var date1: String!
    var date2: String!
    var date: Date!
    var hour1: String!
    var minute1: String!
    var hour2: String!
    var minute2: String!
    var hourDiff: Int!
    var minuteDiff: Int!
    var timeDiff: Int!
    var equalDiff: Int!
    var indexDiff: Int!
    var breakDiff: Int!
    var cumulateSTime: String!
    var cumulateETime: String!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.listData = bl.findAll()
        
        let note = Notes()
        note.date = self.date! as NSDate
        var newnote = Notes()
        
        if(bl.findById(note) == note)
        {
            numSession = 0
            sessionPicker.selectRow(0, inComponent: 0, animated: false)
            sessionPicker.isUserInteractionEnabled = false
            taskDescribe = ""
            sessionTask.text = "<Not Exist>"
            sessionTime.text = "<N/A>"
            
        } else{
  
            newnote = bl.findById(note)!
            
            numSession = Int(newnote.session)!
            
            sessionPicker.isUserInteractionEnabled = true
            sessionPicker.selectRow(numSession-1, inComponent: 0, animated: false)
        
            getTime()
        
            cumulateSTime = ""
            cumulateETime = ""
        
            for i in 1...numSession{
                let timeStart = time2Array.object(at: (i-1)*2) as! String
                let timeEnd = time2Array.object(at: (i-1)*2 + 1) as! String
                cumulateSTime = cumulateSTime + "#" + timeStart
                cumulateETime = cumulateETime + "#" + timeEnd
            }
        }

        self.sessionTable.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        let note = Notes()
        note.date = self.date! as NSDate
        var newnote = Notes()

        if(bl.findById(note) == note)
        {
            numSession = 0
            
        } else{
            newnote = bl.findById(note)!
            newnote.session = String(numSession)
            newnote.sessionstart = cumulateSTime
            newnote.sessionend = cumulateETime
            self.listData = bl.modify(newnote)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionPicker.delegate = self
        self.sessionTable.delegate = self
        self.sessionTable.dataSource = self
        
        self.listData = bl.findAll()
        
        
        if(taskDescribe != nil){
            
            sessionTask.text = taskDescribe
            sessionTime.text = timeBlock
        
            let mstart1 = date1.index(date1.startIndex, offsetBy: 11)
            let mend1 = date1.index(date1.startIndex, offsetBy: 13)
            let mrange1 = mstart1..<mend1
        
            let qstart1 = date2.index(date1.startIndex, offsetBy: 14)
            let qend1 = date2.index(date1.startIndex, offsetBy: 16)
            let qrange1 = qstart1..<qend1
        
            hour1 = date1.substring(with: mrange1)
            minute1 = date1.substring(with: qrange1)
        
            let mstart2 = date2.index(date2.startIndex, offsetBy: 11)
            let mend2 = date2.index(date2.startIndex, offsetBy: 13)
            let mrange2 = mstart2..<mend2
        
            let qstart2 = date2.index(date2.startIndex, offsetBy: 14)
            let qend2 = date2.index(date2.startIndex, offsetBy: 16)
            let qrange2 = qstart2..<qend2
        
            hour2 = date2.substring(with: mrange2)
            minute2 = date2.substring(with: qrange2)
        
            if(hour1 <= hour2){
                hourDiff = Int(hour2)! - Int(hour1)!
            } else{
                hourDiff = Int(hour2)! + 24 - Int(hour1)!
            }
            minuteDiff = Int(minute2)! - Int(minute1)!
            timeDiff = hourDiff * 60 + minuteDiff
        
            NotificationCenter.default.addObserver(self,
                                               selector: #selector(Picker2(_:)),
                                               name: NSNotification.Name(rawValue: "NumberPickerNotification"),
                                               object: nil)
        }
        
        let note = Notes()
        note.date = self.date! as NSDate
        var newnote = Notes()
        
        if(bl.findById(note) == note)
        {
            numSession = 0
            sessionPicker.selectRow(0, inComponent: 0, animated: false)
            sessionPicker.isUserInteractionEnabled = false
            taskDescribe = ""
            sessionTask.text = "<Not Exist>"
            sessionTime.text = "<N/A>"
            
        } else{
            
            newnote = bl.findById(note)!

            numSession = Int(newnote.session)!
            
            sessionPicker.isUserInteractionEnabled = true
            sessionPicker.selectRow(numSession-1, inComponent: 0, animated: false)

            if(numSession <= 5){
                breakDiff = 5
            }else{
                breakDiff = 3
            }
        
            getTime()
        
            cumulateSTime = ""
            cumulateETime = ""
        
            for i in 1...numSession{
                let timeStart = time2Array.object(at: (i-1)*2) as! String
                let timeEnd = time2Array.object(at: (i-1)*2 + 1) as! String
                cumulateSTime = cumulateSTime + "#" + timeStart
                cumulateETime = cumulateETime + "#" + timeEnd
            }
        }

        
        self.sessionTable.reloadData()
 
    }
    
    //sessionPicker Data Source and Delegate Implementation

    func numberOfComponentsInPickerView(sessionPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ sessionPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ sessionPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ sessionPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
       numSession = row + 1
        
        //if(numSession <= 5){
            breakDiff = 5
        //}else{
        //    breakDiff = 3
        //}

       timeDiff = hourDiff * 60 + minuteDiff
       timeDiff = timeDiff - breakDiff * (numSession-1)

       getTime()
        
       cumulateSTime = ""
       cumulateETime = ""
        
       for i in 1...numSession{
            let timeStart = time2Array.object(at: (i-1)*2) as! String
            let timeEnd = time2Array.object(at: (i-1)*2 + 1) as! String
            cumulateSTime = cumulateSTime + "#" + timeStart
            cumulateETime = cumulateETime + "#" + timeEnd
        }
        
       reloadView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Picker2(_ notification : Notification) {
        let textField = notification.object as! UITextField
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        textField.inputView = datePickerView
        timeTextField = textField
        datePickerView.addTarget(self, action: #selector(handleDatePicker2(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker2(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        timeTextField.text = formatter.string(from: sender.date)
        //updateContent()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numSession
    }
 
    
    func reloadView() {
        self.sessionTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessioncell", for: indexPath) as! SessionCell
        
        
        if(taskDescribe != ""){
            cell.sessionNumber.text = String(indexPath.row + 1) + ":"
            cell.sessionStart.text = timeArray.object(at: indexPath.row * 2) as! String
            cell.sessionEnd.text = timeArray.object(at: indexPath.row * 2 + 1) as! String
        }


        
        return cell
    }
    
    func getTime() {
        
        timeArray.removeAllObjects()
        time2Array.removeAllObjects()
        
        var divDiff = Double(timeDiff) / Double(numSession)
        var doubleDiff = round(divDiff)
        equalDiff = Int(doubleDiff)
        
        for index in 0...(numSession-1){
            
            indexDiff = index * equalDiff
            
            var indexHourDiff = (indexDiff / 60)
            var indexMinuteDiff: Int!
            
            if(indexHourDiff >= 1){
                indexMinuteDiff = indexDiff - indexHourDiff * 60
            }else{
                indexMinuteDiff = indexDiff
            }
            
            var retHour = Int(hour1)! + indexHourDiff
            var retMinute = 0
        
            if(index > 0 && numSession > 1){
                retMinute = Int(minute1)! + indexMinuteDiff + breakDiff * index
            } else{
                retMinute = Int(minute1)! + indexMinuteDiff
            }
        
            while(retMinute >= 60){
                retMinute = retMinute - 60
                retHour = retHour + 1
            }
        
            var retMinute2 = retMinute + equalDiff
            var retHour2 = retHour
        
            while(retMinute2 >= 60){
                retMinute2 = retMinute2 - 60
                retHour2 = retHour2 + 1
            }
        
            
            var retTime = ""
            var retTimeHour = ""
            var retTimeMinute = ""
            
            if(retHour  < 10){
                retTimeHour = "0" + String(retHour)
            } else{
                retTimeHour = String(retHour)
            }
            
            if(retMinute  < 10){
                retTimeMinute = "0" + String(retMinute)
            } else{
                retTimeMinute = String(retMinute)
            }

            retTime = retTimeHour + ":" + retTimeMinute
            let retTimeNo = retTimeHour + retTimeMinute
        
            var retTime2: String!
            var retTimeNo2: String!
            let retTimeHour2: String!
            let retTimeMinute2: String!
            
            if(retHour2  < 10){
                retTimeHour2 = "0" + String(retHour2)
            } else{
                retTimeHour2 = String(retHour2)
            }
            
            if(retMinute2  < 10){
                retTimeMinute2 = "0" + String(retMinute2)
            } else{
                retTimeMinute2 = String(retMinute2)
            }
            
            retTime2 = retTimeHour2 + ":" + retTimeMinute2
            retTimeNo2  = retTimeHour2 + retTimeMinute2
        
            if(index == (numSession - 1)){
                retTime2 = String(hour2) + ":" + String(minute2)
                retTimeNo2 = String(hour2) + String(minute2)
            }
            
            timeArray.add(retTime)
            timeArray.add(retTime2)
            time2Array.add(retTimeNo)
            time2Array.add(retTimeNo2)
        }
        
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.calendar.setScope(.month, animated: true)
      }

}
