//
//  AppDialogUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 08/07/2025.
//

import UIKit

enum AppButtonStyle {
    
    case appDefault
    case cancel
    case empty
    
}

struct AppAlertButtonModel {
    
    var labelString : String? = ""
    var style : AppButtonStyle = .appDefault
    var height: CGFloat? = 30
    var width: CGFloat? = 65
    
    init( _ buttonTitle : String, style : AppButtonStyle, height: CGFloat? = 30, width: CGFloat? = 65) {
        self.labelString = buttonTitle
        self.style = style
        self.height = height
        self.width = width
    }
    
}

class AppDialogUI: UIView, NibInstantiatable {
    
    var buttonFont : UIFont? = .systemFont(ofSize: 13)
    
    typealias buttonAction = ((Int, AppDialogUI) -> Void)?
    var action : buttonAction = nil
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var midStackView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @discardableResult
    class func addDialogView(parentView: UIView? = nil, tag: Int? = nil, headerTitle: String? = nil, midViews: [UIView] = [], buttons: [AppAlertButtonModel] = [], closure: buttonAction) -> AppDialogUI {
        
        let keyWindow = parentView == nil ? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow } : parentView
        
        let infoView = AppDialogUI.fromNib()
        infoView.action = closure
        
        infoView.headerTitleLbl.text = headerTitle
        
        if let tag {
            
            for subView in keyWindow?.subviews ?? [] {
                if subView.tag == 11011 {
                    return infoView
                }
            }
            
            infoView.tag = tag
        }
        
        //Set buttons
        let btnCount = buttons.count
        if btnCount > 3 {
            infoView.buttonStackView.axis = .vertical
            infoView.buttonStackView.distribution = .fill
        }
        else {
            infoView.buttonStackView.axis = .horizontal
            infoView.buttonStackView.distribution = .fillEqually
        }
        
        for (index, btn) in buttons.enumerated()  {
            let button = infoView.getButtonWith(btn: btn, stackType: infoView.buttonStackView.axis, index: index)
            infoView.buttonStackView.addArrangedSubview(button)
        }
        
        for midView in midViews {
            infoView.midStackView.addArrangedSubview(midView)
        }
        
        
        DispatchQueue.main.async {
            infoView.frame = keyWindow?.bounds ?? .init()
            keyWindow?.addSubview(infoView)
        }
        return infoView
    }
    
    @objc
    func buttonClicked(_ sender : UIButton) {
        
        if let clouser = self.action {
            clouser(sender.tag, self)
        }
        
    }
    
    fileprivate func getButtonWith ( btn : AppAlertButtonModel, stackType: NSLayoutConstraint.Axis = .horizontal, index : Int) -> UIButton {
        
        let button = UIButton()
        if let height = btn.height {
            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
            button.addConstraints([ heightConstraint])
        }
        
        if stackType == .horizontal {
            if let width = btn.width {
                let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width)
                button.addConstraints([ heightConstraint])
            }
        }
        
//        if index == 0 {
//            let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
//            button.addConstraints([ heightConstraint])
//        }
        
        button.tag = index
        if let font = self.buttonFont {
            button.titleLabel?.font = font
        }
        
        if btn.style != .empty {
            button.setTitle(btn.labelString, for: .normal)
            button.setTitleColor(btn.style == AppButtonStyle.appDefault ? UIColor.white : UIColor.clr_primary, for: .normal)
            button.backgroundColor = btn.style == AppButtonStyle.appDefault ? UIColor.clr_primary : UIColor.white
            if btn.style == .cancel {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clr_primary.cgColor
            }
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
        
    }
    
    
}


