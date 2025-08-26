//
//  GradientView.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 25/04/2025.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
//        if horizontalMode {
//            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
//            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
//        } else {
//            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
//            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
//        }
    }
    func updateLocations() {
        //Old
//        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
        
        //New
//        gradientLayer.locations = [0.0,
//                                   0.23,
//                                   1.0,
//                                   1.0]
        
        let colorCount = gradientLayer.colors?.count ?? 1
        gradientLayer.locations = (0..<colorCount).map { NSNumber(value: Float($0) / Float(colorCount - 1)) }
        
    }
    func updateColors() {
        
        //Old
//        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        //new
//        gradientLayer.colors = [UIColor.white.cgColor,                          // rgba(255, 255, 255, 1) at 0%
//                                UIColor.white.cgColor,                          // rgba(255, 255, 255, 1) at 23%
//                                UIColor(red: 136/255, green: 169/255, blue: 234/255, alpha: 1.0).cgColor, // rgba(136, 169, 234, 1) at 100%
//                                UIColor(red: 17/255, green: 83/255, blue: 213/255, alpha: 0.8).cgColor     // rgba(17, 83, 213, 0.6) at 100%
//                                ]
        
        let currentMode = getDarkModeStatus()
        
        if currentMode == .dark {
            gradientLayer.colors = [
                UIColor.clr_primary.cgColor
            ]
        }
        else {
            gradientLayer.colors = [
                UIColor(hex: "#ffffff").cgColor,
                UIColor(hex: "#faf9fe").cgColor,
                UIColor(hex: "#f4f4fd").cgColor,
                UIColor(hex: "#edeffd").cgColor,
                UIColor(hex: "#e6eafc").cgColor,
                UIColor(hex: "#e3e8fc").cgColor,
                UIColor(hex: "#dfe5fb").cgColor,
                UIColor(hex: "#dce3fb").cgColor,
                UIColor(hex: "#dce3fb").cgColor,
                UIColor(hex: "#dce3fb").cgColor,
                UIColor(hex: "#dce3fb").cgColor,
                UIColor(hex: "#dce3fb").cgColor
            ]
        }
        
        
        
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
        updatePoints()
        updateLocations()
    }

}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
