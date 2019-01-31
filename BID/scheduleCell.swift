//
//  scheduleCell.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/12.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

class scheduleCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var taskItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
