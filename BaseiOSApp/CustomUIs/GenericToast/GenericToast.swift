//
//  GenericToast.swift
//  Plexaar
//
//  Created by Waqas Ashraf on 2/12/24.
//

import UIKit

class GenericToast: UIView, NibInstantiatable{
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    var parentView: UIView?
    
    typealias buttonAction = ((Int, GenericToast) -> Void)?
    var action : buttonAction = nil
    
    class func showToast(uniqueTag: Int? = nil, message: String, parentView: UIView? = nil, backgroundColor: UIColor = .black.withAlphaComponent(0.8), toastMessageColor: UIColor = .white, toastImage: UIImage = .mahjongAvatar, animation: AnimationType = .appear, animationDelay: TimeInterval = 5, completion: buttonAction = nil){
        
        DispatchQueue.main.async {
            
            let width = UIScreen.main.bounds.width * 0.8
            
            let keyWindow = parentView == nil ? UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first : parentView
            
            print("Parent window: \(String(describing: keyWindow))")
            
            //Remove any previous displaying GenericToast
            removePreviousToast(parentView: keyWindow)
            
            let toast = GenericToast.fromNib()
            //
            toast.layer.cornerRadius = 15
            toast.appIcon.layer.cornerRadius = 2
            toast.backgroundColor = backgroundColor
            toast.messageLbl.text = message
            toast.messageLbl.textColor = toastMessageColor
            toast.appIcon.image = toastImage
            toast.parentView = keyWindow
            toast.alpha = animation == .appear ? 0 : 1
            toast.action = completion
            if let uniqueTag {
                toast.tag = uniqueTag
            }
            toast.removeBtn.addTarget(toast, action: #selector (toast.removeToastBtn(_:)), for: .touchUpInside)
            
            let Lblheight = FrameSize(height: message.height(withConstrainedWidth: width - 70, font: .systemFont(ofSize: 18)), width: width - 70)
            print("Label height is: \(Lblheight)")
            
            let isReasonableHeight = Lblheight.height > 40 + 12 + 16
            let calculatedWidth = Lblheight.width + 70
            let isReasonableWidth = calculatedWidth < width
            
            print("Width is: \(width), calculated width is: \(calculatedWidth)")
            
            
            
            toast.frame.size = CGSize(width: isReasonableWidth ? calculatedWidth : width, height: isReasonableHeight ? Lblheight.height + 24 : Lblheight.height + 24)
            toast.center.x = keyWindow?.center.x ?? .init()
            toast.center.y = animation == .popUp ? (keyWindow?.frame.size.height ?? .init()) : animation == .appear ? (keyWindow?.frame.size.height ?? .init())-100 : 50
            
            keyWindow?.addSubview(toast)
            
            UIView.animate(withDuration: animation == .appear ? 0.5 : 0.2, delay: 0, options: animation == .appear ? .curveEaseIn : .curveEaseOut, animations: {
                if animation == .popUp{
                    toast.center.y -= 100
                }
                else if animation == .dropDown{
                    toast.center.y += 100
                }
                else{
                    toast.alpha = 1
                }
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: animationDelay, options: .curveEaseOut, animations: {
                    if animation == .popUp{
                        toast.center.y += 140
                    }
                    else if animation == .dropDown{
                        toast.center.y -= 100
                    }
                    else{
                        toast.alpha = 0
                    }
                }, completion: {_ in
                    toast.removeFromSuperview()
                })
            })
            
        }
        
    }
    
    @objc
    func removeToastBtn(_ sender : UIButton) {
        print("Clicked")
        if let closure = action{
            closure(0, self)
        }
    }
    
    @objc
    static func removePreviousToast(parentView: UIView?, removeInternetToast: Bool = false){
        print("Inside remove function")
        if (parentView?.subviews.count ?? .init()) > 0{
            for view in (parentView?.subviews ?? .init()){
                if removeInternetToast{
                    if view.tag == 600{
                        view.removeFromSuperview()
                    }
                }
                else{
                    if view.tag == 520 || view.tag == 619{
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
}

struct FrameSize{
    var height: CGFloat
    var width: CGFloat
}

enum AnimationType{
    case popUp
    case dropDown
    case appear
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
