//
//  CustomNavigationBar.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 4/26/24.
//

import UIKit

class CustomNavigationBar: UIView, NibInstantiatable{
    
    @IBOutlet weak var leadingImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var trailingImage: UIImageView!
    @IBOutlet weak var leadImageWidth: NSLayoutConstraint!
    
    typealias buttonAction = ((Int, CustomNavigationBar) -> Void)?
    
    var action: buttonAction = nil
    
    @discardableResult
    class func addNavBar(parentView: UIView,
                         showLeadBtn: Bool = true,
                         insert: Bool = false,
                         title: String = "",
                         titleAlignment: NSTextAlignment = .left,
                         titleFont: UIFont? = nil,
                         titleColor: UIColor? = nil,
                         image: UIImage? = .arrow_left,
                         leadImageTintColor: UIColor? = nil,
                         trailingImage: UIImage? = nil,
                         trailingImageTintColor: UIColor? = nil,
                         backgroundColor: UIColor = .clear,
                         completion: buttonAction) -> CustomNavigationBar{
        
        let navBar: CustomNavigationBar = CustomNavigationBar.fromNib()
        navBar.action = completion
        navBar.titleLbl.text = title
        navBar.leadImageWidth.constant = showLeadBtn ? 20 : 0
        navBar.leadingImage.isHidden = !showLeadBtn
        if let titleColor{
            navBar.titleLbl.textColor = titleColor
        }
        if let titleFont{
            navBar.titleLbl.font = titleFont
        }
        navBar.titleLbl.textAlignment = titleAlignment
        
        if let leadImageTintColor{
            navBar.leadingImage.image = image
            navBar.leadingImage.tintColor = leadImageTintColor
        }
        else {
            navBar.leadingImage.image = image?.withRenderingMode(.alwaysTemplate)
            navBar.leadingImage.tintColor = .clr_black_dk
        }
        if let trailingImageTintColor{
            navBar.trailingImage.tintColor = trailingImageTintColor
        }
        navBar.trailingImage.image = trailingImage
        navBar.backgroundColor = backgroundColor
        DispatchQueue.main.async {
            navBar.frame = parentView.bounds
            if let parentStackView = parentView as? UIStackView{
                if insert{
                    parentStackView.insertArrangedSubview(navBar, at: 0)
                }
                else{
                    parentStackView.addArrangedSubview(navBar)
                }
            }
            else{
                parentView.addSubview(navBar)
            }
        }
        return navBar
    }
    
    @IBAction func leadBtn(_ sender: Any) {
        print("Inside pressed")
        if let action{
            action(0, self)
        }
    }
    
    @IBAction func trailingBtn(_ sender: Any) {
        print("Inside pressed")
        if let action{
            action(1, self)
        }
    }
    
}

