//
//  SlistCell.swift
//  PresentationLayer
//
//  Created by yyshen on 2017/9/18.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit

class SlistCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var taskItem: UILabel!
    @IBOutlet weak var currentSession: UILabel!
    @IBOutlet weak var currentProgress: UIProgressView!
    @IBOutlet weak var partialSeesion: UILabel!
    @IBOutlet weak var sessionTime: UILabel!
    @IBOutlet weak var currentPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
