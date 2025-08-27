//
//  CustomOptionCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 27/08/2025.
//

import UIKit

class CustomOptionCell: UICollectionViewCell {
    
    static let identifier = "CustomOptionCell"

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: CustomOptionModel?) {
        titleLbl.text = data?.title
        titleLbl.textColor = data?.isSelected == true ? .white : .label
        containerView.backgroundColor = data?.isSelected == true ? .clr_primary : .clr_gray_3
    }

}
