//
//  TaskScheduleControllerViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/8/30.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit


protocol TaskDelegate: class {
    func updateContent(_ index: IndexPath?, _ start: String?, _ to: String?)
}


class TaskScheduleController: UIViewController {
   
    var taskDescribe: String!
    var index: IndexPath!
    weak var delegate: TaskDelegate?
    

    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var toTime: UITextField!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
 
    @IBOutlet weak var confirmLabel: UILabel!
    
    
    @IBAction func onClickConfirm(_ sender: Any) {
        
        if(startTime.text!.isEmpty){confirmLabel.text = "Please select the start time!!!"}
        else if(toTime.text!.isEmpty){confirmLabel.text = "Please select the to time!!!"}
        
        if(startTime.text!.isEmpty == false && toTime.text!.isEmpty == false)
        {
           confirmLabel.text = "You have confirmed the schedule."
           delegate?.updateContent(index,startTime.text,toTime.text)
        }
        
    }
    
    
    
    @IBAction func onClickStart(_ sender: UITextField) {
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            sender.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
            let formatter = DateFormatter()
            //formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'-'HH:mm"
            startTime.text = formatter.string(from: sender.date)
        
            //if(startTime.text!.isEmpty){confirmLabel.text = "Please select the start time"}
 
    }
    
    @IBAction func onClickTo(_ sender: UITextField) {
        if(startTime.text!.isEmpty){confirmLabel.text = "Please select the start time first!!!"}
        else{confirmLabel.text = "Please select the to time now!!!"}
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker2(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker2(sender: UIDatePicker) {

        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'-'HH:mm"
        toTime.text = formatter.string(from: sender.date)
        
        //if(toTime.text!.isEmpty){confirmLabel.text = "Please select the to time"}
 
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskName.text = taskDescribe
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
