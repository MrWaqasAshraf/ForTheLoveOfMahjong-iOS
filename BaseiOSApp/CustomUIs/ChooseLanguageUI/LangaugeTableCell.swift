//
//  LangaugeTableCell.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 28/11/2024.
//

import UIKit

class LangaugeTableCell: UITableViewCell {
    
    static let identifier = "LangaugeTableCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var circleCheckMarkIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithLangaugeData(data: LangaugeModel?) {
        let isSelected = data?.isSelected == true
        titleLbl.text = data?.languageName
        circleCheckMarkIcon.image = isSelected ? .checkmarkCircleIconSystem : .uncheckCircleIconSystem
        containerView.backgroundColor = isSelected ? .clr_white_purple : .clear
        containerView.layer.borderColor = isSelected ? UIColor.clr_primary.cgColor : UIColor.clr_violet_3.cgColor
    }
    
}
