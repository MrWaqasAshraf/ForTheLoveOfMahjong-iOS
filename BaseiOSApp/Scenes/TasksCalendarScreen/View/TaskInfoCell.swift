//
//  TaskInfoCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 14/08/2025.
//

import UIKit

class TaskInfoCell: UITableViewCell {
    
    static let identifier = "TaskInfoCell"
    
    var closure: (()->())? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inviteBtn(_ sender: Any) {
        print("Clicked")
        if let closure {
            closure()
        }
    }
    
}
