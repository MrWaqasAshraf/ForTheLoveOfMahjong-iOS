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
    @IBOutlet weak var checkmarkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: CustomOptionModel?, forCategory: Bool = false) {
        titleLbl.text = data?.title
        
        containerView.backgroundColor = data?.isSelected == true ? .clr_primary : .clr_gray_3
        
        if forCategory {
            checkmarkView.isHidden = !(data?.isSelected == true)
            titleLbl.textColor = /*data?.isSelected == true ?*/ .white /*: .label*/
            if let category = data?.title {
                switch category {
                case "American":
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_american /*: .clr_gray_3*/
                case "Chinese":
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_chinese /*: .clr_gray_3*/
                case "Hong Kong":
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_yellow /*: .clr_gray_3*/
                case "Riichi":
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_riichie /*: .clr_gray_3*/
                case "Wright Patterson":
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_wright_patterson /*: .clr_gray_3*/
                default:
                    containerView.backgroundColor = /*data?.isSelected == true ?*/ .clr_primary /*: .clr_gray_3*/
                }
            }
        }
        else {
            titleLbl.textColor = data?.isSelected == true ? .white : .label
            checkmarkView.isHidden = true
        }
        
        
    }

}
