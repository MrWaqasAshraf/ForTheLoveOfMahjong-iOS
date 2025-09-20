//
//  ListOptionCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 20/09/2025.
//

import UIKit

class ListOptionCell: UITableViewCell {
    
    static let identifier = "ListOptionCell"

    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: ListOptionModel) {
        titleLbl.text = data.optionValue
    }
    
}
