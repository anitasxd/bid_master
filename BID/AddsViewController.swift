//
//  AddsViewController.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/8/26.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
//import BusinessLogicLayer
//import PersistenceLayer

class AddsViewController: UIViewController, UITextViewDelegate  {

    @IBOutlet weak var txtView: UITextView!
    
    //业务逻辑对象BL
    var bl = NoteBL()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView.delegate = self
        self.txtView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        let note = Notes()
        note.date = NSDate()
        note.content = self.txtView.text
        note.completed = false
        let reslist = bl.create(note)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadViewNotification"), object: reslist, userInfo: nil)
        self.txtView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        

    }

    
    @IBAction func onClickCancel(_ sender: Any) {
               self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
