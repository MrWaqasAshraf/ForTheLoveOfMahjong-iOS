//
//  LanguageHelper.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 05/08/2025.
//

import UIKit

extension String {
    func localizeString(string: String = appSelectedLanguage?.languageSymbol ?? "en", originalText: String? = nil) -> String {
        
        print("Selected language code: \(string)")
        
        if let path = Bundle.main.path(forResource: string, ofType: "lproj") {
            let bundle = Bundle(path: path)
            let localizedStr = NSLocalizedString(self, tableName: nil, bundle: bundle!,
                                                 value: "", comment: "")
            print("Localized value: \(localizedStr)")
            return localizedStr
        }
        else {
            return originalText ?? self
        }
        
    }
    
}

extension UIButton {
    
    @IBInspectable
    var setLanguage: String? {
        get {
            return nil
        }
        set {
            let selectedLanguage = appSelectedLanguage
            if let selectedLanguage {
                let currentTitle = title(for: .normal)
                setTitle(currentTitle?.localizeString(originalText: currentTitle), for: .normal)
            }
        }
    }
    
}

extension UILabel {
    
    @IBInspectable
    var setLanguage: String? {
        get {
            return nil
        }
        set {
            let selectedLanguage = appSelectedLanguage
            if let selectedLanguage {
                text = text?.localizeString(string: selectedLanguage.languageSymbol, originalText: text)
            }
        }
    }
    
}

extension UITextField{
    
    @IBInspectable
    var placeholderColor: UIColor? {
        get {
            if let placeholderColor = self.placeholderColor {
                attributedPlaceholder = NSAttributedString(
                    string: "\(placeholder ?? "")".localizeString(originalText: "\(placeholder ?? "")"),
                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
                )
                return placeholderColor
            }
            else {
                placeholder = "\(placeholder ?? "")".localizeString(originalText: "\(placeholder ?? "")")
                return nil
            }
        }
        set {
            attributedPlaceholder = NSAttributedString(
                string: "\(placeholder ?? "")".localizeString(originalText: "\(placeholder ?? "")"),
                attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .blue]
            )
        }
    }
    
    @IBInspectable
    var setLanguage: String? {
        get {
            return nil
        }
        set {
            let selectedLanguage = appSelectedLanguage
            if let selectedLanguage {
                if let placeholder {
                    self.placeholder = placeholder.localizeString(string: selectedLanguage.languageSymbol, originalText: placeholder)
                }
                else if let attributedPlaceholder {
                    self.attributedPlaceholder =  NSAttributedString(
                        string: "\(placeholder ?? "")".localizeString(originalText: "\(placeholder ?? "")")
                    )
                }
                
            }
        }
    }
    
}
