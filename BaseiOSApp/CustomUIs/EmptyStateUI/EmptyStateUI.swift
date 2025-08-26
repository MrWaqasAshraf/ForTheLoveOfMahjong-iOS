//
//  EmptyStateUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 5/28/24.
//

import UIKit

class EmptyStateUI: UIView, NibInstantiatable {
    
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    typealias buttonAction = ((EmptyStateUI) -> Void)?
    
    var action: buttonAction = nil
    
    @discardableResult
    class func addStateUi(parentView: UIView,
                         insert: Bool = false,
                         title: String = "No items available",
                         titleAlignment: NSTextAlignment = .center,
                         titleFont: UIFont? = nil,
                         titleColor: UIColor? = nil,
                         image: UIImage = .doc_icon_medium,
                         leadImageTintColor: UIColor? = nil,
                         backgroundColor: UIColor = .clear,
                         completion: buttonAction) -> EmptyStateUI{
        
        let stateUi: EmptyStateUI = EmptyStateUI.fromNib()
        stateUi.action = completion
        stateUi.titleLbl.text = title
        if let titleColor{
            stateUi.titleLbl.textColor = titleColor
        }
        if let titleFont{
            stateUi.titleLbl.font = titleFont
        }
        stateUi.titleLbl.textAlignment = titleAlignment
        stateUi.stateImage.image = image
        if let leadImageTintColor{
            stateUi.stateImage.tintColor = leadImageTintColor
        }
        stateUi.backgroundColor = backgroundColor
        stateUi.containerView.backgroundColor = backgroundColor
        DispatchQueue.main.async {
            stateUi.frame = parentView.bounds
            if let parentStackView = parentView as? UIStackView{
                if insert{
                    parentStackView.insertArrangedSubview(stateUi, at: 0)
                }
                else{
                    parentStackView.addArrangedSubview(stateUi)
                }
            }
            else{
                parentView.addSubview(stateUi)
            }
        }
        
        return stateUi
    }
    
}
