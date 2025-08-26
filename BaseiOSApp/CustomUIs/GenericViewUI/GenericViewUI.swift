//
//  GenericViewUI.swift
//  quickcard
//
//  Created by Waqas Ashraf on 10/04/2023.
//

import UIKit

class GenericViewUI: UIView, NibInstantiatable {

    static let ideintifier = "GenericViewUI"
    
    typealias buttonAction = ((Int, GenericViewUI) -> Void)?
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var customStack: UIStackView!
    @IBOutlet weak var scrollVIew: UIScrollView!
    
    //Constraints
    @IBOutlet weak var headLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttomStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLblTopConstraint: NSLayoutConstraint!
    
    var action : buttonAction = nil
    
    var buttonFont : UIFont? = UIFont.boldSystemFont(ofSize: 16)
    
    class func showAlertWith (_ title : String, titleColor: UIColor?, detail : String, _ image : UIImage? = .checkmark, ImageTintColor: UIColor? = nil, _ buttons : [AppAlertButton] = [], buttonsTopSpace: CGFloat = 300, stackSpacing: CGFloat = 10, completion : buttonAction = nil) {
        
        let alert = GenericViewUI.fromNib()
        alert.action = completion
        alert.frame = UIScreen.main.bounds
        
        // set Labels
        alert.titleLbl.text = title
        alert.titleLbl.textColor = titleColor
        alert.descriptionLbl.text = detail
        alert.customStack.spacing = stackSpacing
//        alert.buttonStackTopConstraint.constant = buttonsTopSpace
        if let imageAvailable = image {
            alert.viewImage.image = imageAvailable
        }
        if let ImageTintColor {
            alert.viewImage.tintColor = ImageTintColor
        }
        let screenSize = UIScreen.main.bounds
        
        var imageSize = alert.viewImage.image?.size
        AppLogger.info("Image size is: \(String(describing: imageSize))")
       
        //Set buttons
        var stackSize: CGFloat = 0
        for (index, btn) in buttons.enumerated()  {
            stackSize = stackSize+64
            let button = CustomButtonMaker.getButtonWith(btn: btn, index: index, height: btn.height)
            button.addTarget(alert, action: #selector(alert.buttonClicked(_:)), for: .touchUpInside)
            alert.customStack.addArrangedSubview(button)
        }
        
        
        if alert.scrollVIew.bounds.height > screenSize.height{
            
            //re-adjust frames
            AppLogger.info("View will re rescaled")
            alert.imageTopConstraint.constant = screenSize.height*0.1
            alert.viewImage.transform = CGAffineTransformScale(alert.viewImage.transform, 0.8, 0.8)
            imageSize = CGSize(width: (imageSize?.width ?? .init())*0.8, height: (imageSize?.height ?? .init())*0.8)
            AppLogger.info("Re-adjusted Image size is: \(String(describing: imageSize))")
        }
        
        let descriptionHeight = detail.getStringSize(subtractWidth: 64)
        let totalViewHeight = alert.scrollVIew.bounds.height + alert.imageTopConstraint.constant /* - 133 */ /* - 128 - 200 */ /* - 238  - 20.33 */ - 258.33 - 133 + descriptionHeight.height + stackSize + (imageSize?.height ?? .init())
        
        let adjustableHeight = totalViewHeight - screenSize.height
        
        AppLogger.info("Stack size: \(stackSize)")
        AppLogger.info("Scroll height is: \(alert.scrollVIew.bounds.height), Screen height: \(screenSize.height)")
        AppLogger.info("Title label height is: \(alert.titleLbl.frame.height), Desc label height is \(descriptionHeight.height)")
        AppLogger.info("Total view height is: \(totalViewHeight)")
        AppLogger.info("Adjustable height is: \(adjustableHeight)")
        
        if adjustableHeight > 0{
            let buttonTopHeight = alert.buttonStackTopConstraint.constant - adjustableHeight
            alert.buttonStackTopConstraint.constant = buttonTopHeight <= 0 ? 16 : buttonTopHeight
        }
        else{
            let buttonTopHeight = alert.buttonStackTopConstraint.constant + abs(adjustableHeight)
            alert.buttonStackTopConstraint.constant = buttonTopHeight
        }

        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        DispatchQueue.main.async {
            alert.alpha = 0
            alert.frame = keyWindow?.bounds ?? .init()
            
            keyWindow?.addSubview(alert)
            alert.setNeedsLayout()
            alert.layoutIfNeeded()
            UIView.animate(withDuration: 0.1, delay: 0, options: .transitionFlipFromTop) {
                alert.alpha = 1
//                alert.alertContainer.transform = .identity
            } completion: { _ in }
        }
        
        
    }
    
    @objc
    func buttonClicked(_ sender : UIButton) {
        
        if let clouser = self.action {
            clouser(sender.tag, self)
        }
        
    }
    
}

extension String{
    func getStringSize(subtractWidth: CGFloat) -> FrameSize{
        let setWidth = (UIScreen.main.bounds.width) - subtractWidth
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: setWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = self
        label.sizeToFit()
        AppLogger.info("Label width is: \(label.frame.width)")
        return FrameSize(height: self.height(withConstrainedWidth: setWidth, font: .systemFont(ofSize: 18)), width: label.frame.width)
    }
}


