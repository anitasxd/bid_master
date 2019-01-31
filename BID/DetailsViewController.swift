//
//  DetailsViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/8/26.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
//import BusinessLogicLayer
//import PersistenceLayer

class DetailsViewController: UIViewController, UITextViewDelegate {

    //业务逻辑对象BL
    var bl = NoteBL()

    var preDate: NSDate!
    var completed: Bool!
    
    @IBOutlet weak var txtView: UITextView!
  
    @IBOutlet weak var congratLabel: UILabel!
    
    @IBOutlet weak var completedBtn: UIBarButtonItem!
    
    @IBAction func OnClickSave(_ sender: Any) {
        let note = Notes()
     
        note.date = preDate
        note.content = self.txtView.text
        note.completed = false
        let reslist = bl.modify(note)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadViewNotification"), object: reslist, userInfo: nil)
        self.txtView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnClickDone(_ sender: Any) {
        let note = Notes()

        note.date = preDate
        note.content = self.txtView.text
        note.completed = true
        let reslist = bl.modify(note)
        
        if(completedBtn.title == "Done"){
            completedBtn.title = "Not Yet"
            self.txtView.backgroundColor = UIColor.lightGray
            self.txtView.textColor = UIColor.white
            self.txtView.isEditable = false
            self.congratLabel.text = "Congrats for job done!!"
            
        } else{
            completedBtn.title = "Done"
            self.txtView.backgroundColor = UIColor.white
            self.txtView.textColor = UIColor.black
            self.txtView.isEditable = true
            self.congratLabel.text = "Revise the task as you want!"
            self.txtView.becomeFirstResponder()
        }
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadViewNotification"), object: reslist, userInfo: nil)
        self.txtView.resignFirstResponder()
    }

    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Notes = self.detailItem as? Notes {
             if let textview = self.txtView {
                textview.text = detail.content
                //textview.layer.borderColor = UIColor.gray
                textview.layer.borderWidth = 1.0
                textview.layer.cornerRadius = 5.0
                self.preDate = detail.date
                self.completed = detail.completed
            }
            //if let label = self.detailDescriptionLabel {
            //    label.text = detail.content
            //}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
