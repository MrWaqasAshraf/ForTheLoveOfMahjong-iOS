//
//  AlertUIs.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 5/21/24.
//

import UIKit

class GenericAlert{
    
    struct AlertActions{
        var title: String
        var style: UIAlertAction.Style
    }
    
    struct TextFieldAction {
        var identifier: Int
        var placeholder: String
        var keyboardType: UIKeyboardType = .default
    }
    
    struct TextFieldValue {
        var textFieldValue: String?
    }
    
    static func showAlert(title: String = "", message: String = "", textFieldActions: [TextFieldAction]? = nil, actions: [AlertActions], controller: UIViewController? = nil, handler: ((UIAlertAction?, Int, [TextFieldValue]?) -> Void)? = nil){
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let vc = controller == nil ? keyWindow?.rootViewController : controller else{
            return
        }
        
        let alert = UIAlertController(title: title == "" ? "ZeroIFTA" : title, message: message == "" ? "Alert" : message, preferredStyle: .alert)
        
        for (index, action) in actions.enumerated(){
            let setAction = UIAlertAction(title: action.title, style: action.style) { actionAlrt in
                if let handler = handler {
                    let textFieldValues = alert.textFields?.compactMap({ TextFieldValue(textFieldValue: $0.text) })
                    handler(actionAlrt, index, textFieldValues)
                }
            }
            alert.addAction(setAction)
        }
        
        for textFieldAction in textFieldActions ?? [] {
            alert.addTextField { textField in
                textField.tag = textFieldAction.identifier
                textField.placeholder = textFieldAction.placeholder
                textField.keyboardType = textFieldAction.keyboardType
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}
