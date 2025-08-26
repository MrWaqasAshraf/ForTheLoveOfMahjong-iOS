//
//  InfoUI.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 02/03/2025.
//

import UIKit

class InfoUI: UIView, NibInstantiatable {
    
    typealias buttonAction = (InfoUI, Int) -> Void?
    private var action: buttonAction? = nil
    
    @discardableResult
    class func addInfoView(parentView: UIView? = nil, closure: @escaping buttonAction) -> InfoUI {
        let infoView = InfoUI.fromNib()
        infoView.action = closure
        let keyWindow = parentView == nil ? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow } : parentView
        DispatchQueue.main.async {
            infoView.frame = keyWindow?.bounds ?? .init()
            keyWindow?.addSubview(infoView)
        }
        return infoView
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
}
