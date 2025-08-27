//
//  SideMenuOptionCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 27/08/2025.
//

import UIKit

class SideMenuOptionCell: UITableViewCell {
    
    static let identifier = "SideMenuOptionCell"

    @IBOutlet weak var leadIconImage: UIImageView!
    @IBOutlet weak var trailingIconImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: SideMenuOptionModel) {
        leadIconImage.image = UIImage(systemName: data.image)
        titleLbl.text = data.title
        modeSwitch.isHidden = !(data.slug == .darkMode)
        trailingIconImage.isHidden = data.slug == .darkMode
    }
    
}
