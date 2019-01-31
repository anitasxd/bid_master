//
//  AgendaTableViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/8/26.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
//import BusinessLogicLayer
//import PersistenceLayer

class AgendaTableViewController: UITableViewController { //TaskDelegate {

    var listData = NSMutableArray()
    var bl = NoteBL()
    var timeTextField: UITextField!
    
    
    @IBAction func onClickSave(_ sender: Any) {
        self.view.endEditing(true)
        saveContent()
    }
    
    func saveContent(){
        
        let indexPaths = self.tableView.indexPathsForVisibleRows
        
        for indexPath in indexPaths! {
            
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomCell
            
            let note = Notes()
            note.date = (self.listData[indexPath.row] as! Notes).date
            note.content = cell.titleText.text!
            note.completed = cell.checkBox.isChecked
            note.start = cell.startTimeText.text!
            note.to = cell.toTimeText.text!
            note.session = (self.listData[indexPath.row] as! Notes).session
            
            if((self.listData[indexPath.row] as! Notes).sessionstart != "#0000" &&  (self.listData[indexPath.row] as! Notes).sessionstart != "")
            {
                note.sessionstart = (self.listData[indexPath.row] as! Notes).sessionstart
            }else
            {
                let mstart = note.start.index(note.start.startIndex, offsetBy: 11)
                let mend = note.start.index(note.start.startIndex, offsetBy: 13)
                let mrange = mstart..<mend
                
                let mestart = note.start.index(note.start.startIndex, offsetBy: 14)
                let meend = note.start.index(note.start.startIndex, offsetBy: 16)
                let merange = mestart..<meend
                
                note.sessionstart = "#" + note.start.substring(with: mrange) + note.start.substring(with: merange)
            }
            
            if((self.listData[indexPath.row] as! Notes).sessionend != "#0000" &&  (self.listData[indexPath.row] as! Notes).sessionend != "")
            {
                note.sessionend = (self.listData[indexPath.row] as! Notes).sessionend
            }else
            {
                let qstart = note.to.index(note.to.startIndex, offsetBy: 11)
                let qend = note.to.index(note.to.startIndex, offsetBy: 13)
                let qrange = qstart..<qend
                
                let qestart = note.to.index(note.to.startIndex, offsetBy: 14)
                let qeend = note.to.index(note.to.startIndex, offsetBy: 16)
                let qerange = qestart..<qeend
                
                note.sessionend = "#" + note.to.substring(with: qrange) + note.to.substring(with: qerange)
            }
            
            self.listData = bl.modify(note)
            if(cell.checkBox.isChecked) {cell.checkBox.isEnabled = false}
        }
    }

    
    func updateContent(){
        
        let indexPaths = self.tableView.indexPathsForVisibleRows
        
        for indexPath in indexPaths! {
            
            let cell = self.tableView.cellForRow(at: indexPath) as! CustomCell
            
            let note = Notes()
            note.date = (self.listData[indexPath.row] as! Notes).date
            
            let newnote = bl.findById(note)!
            newnote.content = cell.titleText.text!
            newnote.completed = cell.checkBox.isChecked
            newnote.start = cell.startTimeText.text!
            
            if(cell.toTimeText.text! == "Pick to Time.."){
                newnote.to = newnote.start
            } else{
                //print("cell.startTimeText.text - " + cell.startTimeText.text!)
                //print("cell.toTimeText.text - " + cell.toTimeText.text!)
                newnote.to = cell.toTimeText.text!
            }
            
          
            let mstart = newnote.start.index(newnote.start.startIndex, offsetBy: 11)
            let mend = newnote.start.index(newnote.start.startIndex, offsetBy: 13)
            let mrange = mstart..<mend
                
            let mestart = newnote.start.index(newnote.start.startIndex, offsetBy: 14)
            let meend = newnote.start.index(newnote.start.startIndex, offsetBy: 16)
            let merange = mestart..<meend
                
            newnote.sessionstart = "#" + newnote.start.substring(with: mrange) + newnote.start.substring(with: merange)

            let qstart = newnote.to.index(newnote.to.startIndex, offsetBy: 11)
            let qend = newnote.to.index(newnote.to.startIndex, offsetBy: 13)
            let qrange = qstart..<qend
                
            let qestart = newnote.to.index(newnote.to.startIndex, offsetBy: 14)
            let qeend = newnote.to.index(newnote.to.startIndex, offsetBy: 16)
            let qerange = qestart..<qeend
                
            newnote.sessionend = "#" + newnote.to.substring(with: qrange) + newnote.to.substring(with: qerange)
            
            self.listData = bl.modify(newnote)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
   
    @IBAction func onClickAdd(_ sender: Any) {
        
            updateContent()
        
            var addNote = Notes()
            addNote.date = NSDate()
            addNote.content = "Input here...."
            addNote.completed = false
            addNote.start = "Pick Start Time.."
            addNote.to = "Pick to Time.."
            addNote.session = "1"
            addNote.sessionstart = "#0000"
            addNote.sessionend = "#0000"
        
            self.listData = bl.create(addNote)
            //isNewNote = true
        
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadViewNotification"), object: self.listData, userInfo: nil)
        
            // Scroll the tableView so the new item is visible
            let indexPathOfNewItem =  IndexPath.init(row: self.listData.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPathOfNewItem, at: UITableViewScrollPosition.bottom, animated: true)
    }

  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //查询所有的数据
        self.listData = bl.findAll()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadView(_:)),
                                               name: NSNotification.Name(rawValue: "reloadViewNotification"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Picker(_:)),
                                               name: NSNotification.Name(rawValue: "PickerNotification"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Picker2(_:)),
                                               name: NSNotification.Name(rawValue: "PickerNotification2"),
                                               object: nil)

    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.tableView.reloadData()
        
    }
 */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        updateContent()
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let note = self.listData[indexPath.row] as! Notes
        
        cell.titleText.text = note.content
        cell.startTimeText.text = note.start
        cell.toTimeText.text = note.to
        cell.titleText.frame.origin.x = cell.checkBox.frame.origin.x + cell.checkBox.frame.size.width + 2
        cell.startTimeText.frame.origin.x = cell.checkBox.frame.origin.x + cell.checkBox.frame.size.width + 2
        cell.toTimeText.frame.origin.x = cell.startTimeText.frame.origin.x + cell.startTimeText.frame.width + 15
        
        cell.checkBox.addTarget(self, action: #selector(checkboxTouched(_:)),for: UIControlEvents.valueChanged)
        
        if(note.completed){
            cell.checkBox.isChecked = true
            cell.checkBox.isEnabled = false
            
            cell.startTimeText.isEnabled = false
            cell.startTimeText.textColor = UIColor.white
            
            cell.toTimeText.isEnabled = false
            cell.toTimeText.textColor = UIColor.white
            
            cell.titleText.isEnabled = false
            cell.titleText.textColor = UIColor.white
            
            cell.backgroundColor = UIColor.lightGray
        }
        
        // Accessibility
        self.updateAccessibilityForCell(cell: cell)

        return cell
    }
    
    @objc func checkboxTouched(_ sender : CheckBox){
        //print("checkbix is selected")
        if (!sender.isChecked){
            ((sender.superview?.superview) as! CustomCell).backgroundColor = UIColor.white
            
            ((sender.superview?.superview) as! CustomCell).titleText.isEnabled = true
            //((sender.superview?.superview) as! CustomCell).titleText.backgroundColor = UIColor.white
            ((sender.superview?.superview) as! CustomCell).titleText.textColor = UIColor.black
            
            ((sender.superview?.superview) as! CustomCell).startTimeText.isEnabled = true
            //((sender.superview?.superview) as! CustomCell).startTimeText.backgroundColor = UIColor.white
            ((sender.superview?.superview) as! CustomCell).startTimeText.textColor = UIColor.black

            ((sender.superview?.superview) as! CustomCell).toTimeText.isEnabled = true
            //((sender.superview?.superview) as! CustomCell).toTimeText.backgroundColor = UIColor.white
            ((sender.superview?.superview) as! CustomCell).toTimeText.textColor = UIColor.black

       
        }
        else{
            ((sender.superview?.superview) as! CustomCell).backgroundColor = UIColor.lightGray

            ((sender.superview?.superview) as! CustomCell).titleText.isEnabled = false
            //((sender.superview?.superview) as! CustomCell).titleText.backgroundColor = UIColor.orange
            ((sender.superview?.superview) as! CustomCell).titleText.textColor = UIColor.white
            
            ((sender.superview?.superview) as! CustomCell).startTimeText.isEnabled = false
            //((sender.superview?.superview) as! CustomCell).startTimeText.backgroundColor = UIColor.orange
            ((sender.superview?.superview) as! CustomCell).startTimeText.textColor = UIColor.white
            
            ((sender.superview?.superview) as! CustomCell).toTimeText.isEnabled = false
            //((sender.superview?.superview) as! CustomCell).toTimeText.backgroundColor = UIColor.orange
            ((sender.superview?.superview) as! CustomCell).toTimeText.textColor = UIColor.white
        }
    }
    
    func updateAccessibilityForCell(cell: CustomCell)
    {
        // The cell's accessibilityValue is the Checkbox's accessibilityValue.
        cell.accessibilityValue = cell.checkBox.accessibilityValue;
    }

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let note = self.listData[indexPath.row] as! Notes
            self.listData = bl.remove(note)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateContent()
        }
   
    }
    
    @objc func reloadView(_ notification : Notification) {
        let resList = notification.object as! NSMutableArray
        self.listData = resList
        self.tableView.reloadData()
    }
    
    @objc func Picker(_ notification : Notification) {
        let textField = notification.object as! UITextField
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var minDateComponent = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: Date())
        minDateComponent.minute = minute
        minDateComponent.hour = hour
        minDateComponent.day = day
        minDateComponent.month = month
        minDateComponent.year = year
        
        //calendar.timeZone = .current
        let minDate = calendar.date(from: minDateComponent)
        
        var maxDateComponent = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: Date())
        maxDateComponent.minute = 59
        maxDateComponent.hour = 23
        maxDateComponent.day = 15
        maxDateComponent.month = 6
        maxDateComponent.year = 2018
        
        let maxDate = calendar.date(from: maxDateComponent)
        
        datePickerView.minimumDate = minDate! as Date
        datePickerView.maximumDate =  maxDate! as Date
        
        textField.inputView = datePickerView
        timeTextField = textField
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'-'HH:mm"
        timeTextField.text = formatter.string(from: sender.date)
        updateContent()
    }
    
    @objc func Picker2(_ notification : Notification) {
        let textField = notification.object as! UITextField
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var minDateComponent = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: Date())
        minDateComponent.minute = minute
        minDateComponent.hour = hour
        minDateComponent.day = day
        minDateComponent.month = month
        minDateComponent.year = year
        
        let minDate = calendar.date(from: minDateComponent)
        
        var maxDateComponent = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: Date())
        maxDateComponent.minute = 59
        maxDateComponent.hour = 23
        maxDateComponent.day = 15
        maxDateComponent.month = 6
        maxDateComponent.year = 2018
        
        let maxDate = calendar.date(from: maxDateComponent)
        
        datePickerView.minimumDate = minDate! as Date
        datePickerView.maximumDate =  maxDate! as Date

        textField.inputView = datePickerView
        timeTextField = textField
        datePickerView.addTarget(self, action: #selector(handleDatePicker2(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker2(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'-'HH:mm"
        timeTextField.text = formatter.string(from: sender.date)
        updateContent()
    }


}
