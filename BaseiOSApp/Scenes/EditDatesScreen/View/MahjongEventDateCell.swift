//
//  MahjongEventDateCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 06/09/2025.
//

import UIKit

class MahjongEventDateCell: UITableViewCell {
    
    static let identifier = "MahjongEventDateCell"

    @IBOutlet weak var titleLbl: UILabel!
    
    var closure: (()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: SelectedEventDateTime?) {
        titleLbl.text = data?.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - hh:mm a")
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        if let closure {
            closure()
        }
    }
    
    
}
