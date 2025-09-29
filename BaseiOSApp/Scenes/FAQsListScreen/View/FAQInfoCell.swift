//
//  FAQInfoCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 29/09/2025.
//

import UIKit

class FAQInfoCell: UITableViewCell {
    
    static let identifier = "FAQInfoCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var subtitleView: UIView!
    @IBOutlet weak var expandedIconImage: UIImageView!
    
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: FaqsData?) {
        
        expandedIconImage.image = data?.isExpanded == true ? .arrow_up_rect_system_icon : .arrow_down_rect_system_icon
        titleLbl.text = data?.question
        subtitleLbl.text = data?.answer
        subtitleView.isHidden = !(data?.isExpanded == true)
        
    }
    
    @IBAction func expandBtn(_ sender: Any) {
        if let closure {
            closure()
        }
    }
    
    
}
