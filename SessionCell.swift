//
//  SessionCell.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/14.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {

    @IBOutlet weak var sessionNumber: UILabel!
    @IBOutlet weak var sessionStart: UITextField!
    @IBOutlet weak var sessionEnd: UITextField!
    
    @IBAction func onClickStart(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NumberPickerNotification"), object: self.sessionStart, userInfo: nil)
    }
    
    @IBAction func onClickEnd(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NumberPickerNotification"), object: self.sessionEnd, userInfo: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
