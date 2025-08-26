//
//  PhotoOptionsBottomSheet.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 14/05/2024.
//

import UIKit

class PhotoOptionsBottomSheet: UIView, NibInstantiatable{
    
    typealias buttonAction = ((Int, PhotoOptionsBottomSheet) -> Void)?
    var action : buttonAction = nil
    
    @discardableResult
    class func showBottomSheet(parentView: UIView, insert: Bool = false, completion: buttonAction = nil) -> PhotoOptionsBottomSheet{
        let bottomSheet = PhotoOptionsBottomSheet.fromNib()
        bottomSheet.action = completion
        DispatchQueue.main.async {
            bottomSheet.frame = parentView.bounds
            if let parentStackView = parentView as? UIStackView{
                if insert{
                    parentStackView.insertArrangedSubview(bottomSheet, at: 0)
                }
                else{
                    parentStackView.addArrangedSubview(bottomSheet)
                }
            }
            else{
                parentView.addSubview(bottomSheet)
            }
        }
        return bottomSheet
        
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        if let action{
            action(0, self)
        }
    }
    @IBAction func galleryBtn(_ sender: Any) {
        if let action{
            action(1, self)
        }
    }
    @IBAction func closeBtn(_ sender: Any) {
        self.removeFromSuperview()
    }
}
