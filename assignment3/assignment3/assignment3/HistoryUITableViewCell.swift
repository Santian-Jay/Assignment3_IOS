//
//  HistoryUITableViewCell.swift
//  assignment3
//
//  Created by 小星星的三天 on 8/5/2022.
//

import UIKit

class HistoryUITableViewCell: UITableViewCell {

    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var completed: UILabel!
    @IBOutlet var round: UILabel!
    
    
    @IBOutlet var fStartTime: UILabel!
    @IBOutlet var fEndTime: UILabel!
    @IBOutlet var fDuration: UILabel!
    @IBOutlet var fRound: UILabel!
    @IBOutlet var fCompleted: UILabel!
    
    
    @IBOutlet var uStartTime: UILabel!
    @IBOutlet var uEndTime: UILabel!
    @IBOutlet var uDuration: UILabel!
    @IBOutlet var uRound: UILabel!
    @IBOutlet var uCompleted: UILabel!
    
    
    
    @IBOutlet var start: UILabel!
    @IBOutlet var end: UILabel!
    @IBOutlet var dura: UILabel!
    @IBOutlet var rou: UILabel!
    @IBOutlet var comple: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
