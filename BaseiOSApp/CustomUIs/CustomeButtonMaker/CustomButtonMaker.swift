//
//  CustomButtonMaker.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 19/01/2025.
//

import UIKit

enum AppAlertButtonStyle {
    
    case primary
    case secondary
    case labelButton
    
}

struct AppAlertButton {
    
    var labelString : String? = ""
    var style : AppAlertButtonStyle = .primary
    var height: CGFloat
    var buttonFont: UIFont
    var cornerRadius: CGFloat?
    
    init( _ buttonTitle : String, style : AppAlertButtonStyle, _ buttonFont: UIFont = UIFont.boldSystemFont(ofSize: 16), cornerRadius: CGFloat? = nil, height: CGFloat = 50) {
        
        self.labelString = buttonTitle
        self.style = style
        self.buttonFont = buttonFont
        self.cornerRadius = cornerRadius
        self.height = height
    }
    
}

class CustomButtonMaker{
    
    class func getButtonWith ( btn : AppAlertButton, index : Int, height: CGFloat = 50) -> UIButton {
        
        let button = UIButton()
        if index == 0 {
            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
            button.addConstraints([ heightConstraint])
        }
        button.tag = index
        button.titleLabel?.font = btn.buttonFont
        button.titleLabel?.textColor = btn.style == AppAlertButtonStyle.primary ? .white : .clr_primary
        
        button.setTitle(btn.labelString, for: .normal)
        button.setTitleColor(btn.style == AppAlertButtonStyle.primary ? UIColor.white : UIColor.clr_primary, for: .normal)
        button.backgroundColor = btn.style == AppAlertButtonStyle.primary ? UIColor.clr_primary : UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = btn.style == AppAlertButtonStyle.secondary ? UIColor.clr_primary.cgColor : UIColor.clear.cgColor
        button.layer.borderWidth = btn.style == AppAlertButtonStyle.secondary ? 2 : 0
        if let cornerRadius = btn.cornerRadius {
            button.layer.cornerRadius =  cornerRadius
        }
        else {
            button.layer.cornerRadius =  10
        }
        return button
        
    }
    
}
