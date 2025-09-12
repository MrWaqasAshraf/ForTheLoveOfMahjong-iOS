//
//  UIViewHelper.swift
//  truckerApp
//
//  Created by Waqas Ashraf on 4/26/24.
//

import UIKit
//import MaterialComponents

//extension MDCOutlinedTextField: UITextFieldDelegate{
//    
//    func setupTextField(height: CGFloat = 50, cornerRadius: CGFloat = 10, outlineColor: UIColor = .clr_primary, floatLabelClr: UIColor = .clr_primary, normalColor: UIColor = .clr_whitish_gray, inputBackgroundColor: UIColor = .clr_whitish_gray){
//        label.text = placeholder
//        setNormalLabelColor(UIColor.clr_violet, for: .normal)
//        setOutlineColor(outlineColor, for: .editing)
//        setOutlineColor(normalColor, for: .normal)
//        setFloatingLabelColor(floatLabelClr, for: .editing)
//        setFloatingLabelColor(floatLabelClr, for: .normal)
//        containerRadius = cornerRadius
//        preferredContainerHeight = height
//        verticalDensity = height
//        tintColor = .systemBlue
//        self.delegate = self
//    }
//    
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text, text != ""{
//            setOutlineColor(.clr_primary, for: .normal)
//        }
//        else{
//            setOutlineColor(.clr_whitish_gray, for: .normal)
//        }
//    }
//    
//}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}

struct AttributeModel{
    var name: NSAttributedString.Key
    var value: Any
    var range: NSRange
}

extension NSMutableAttributedString{
    
    func makeRange(rangeString: String) -> NSRange{
        let range = (self.string as NSString).range(of: rangeString)
        print("String \(self.string) range \(rangeString) is: \(range)")
        return range
    }
    
    func setupAttributes(attributes: [AttributeModel]){
        for attribute in attributes {
            self.addAttribute(attribute.name, value: attribute.value, range: attribute.range)
        }
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
            
        }
        set {
            layer.cornerRadius = newValue
            
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            self.layoutIfNeeded()
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            self.layoutIfNeeded()
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            self.layoutIfNeeded()
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                self.layoutIfNeeded()
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
                self.layoutIfNeeded()
            } else {
                layer.shadowColor = nil
                self.layoutIfNeeded()
            }
        }
    }
}

extension UIButton {
    
    @IBInspectable
    var setTitleWithStateColor: String? {
        get {
            return nil
        }
        set {
            if let newValue {
                if newValue != "" {
                    let config: UIButton.ConfigurationUpdateHandler = { [weak self] button in
                        var config = button.configuration
                        config?.attributedTitle = AttributedString(NSLocalizedString(newValue, comment: ""),
                                                                   attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: button.isEnabled ? UIColor.white : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]))
                        button.configuration = config
                    }
                    self.configurationUpdateHandler = config
                }
                else {
                    self.configurationUpdateHandler = nil
                }
            }
            else {
                self.configurationUpdateHandler = nil
            }
        }
    }
    
    func manageAttributedTitleWithValue(newValue: String) {
        let config: UIButton.ConfigurationUpdateHandler = { [weak self] button in
            var config = button.configuration
            config?.attributedTitle = AttributedString(NSLocalizedString(newValue, comment: ""),
                                                       attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: button.isEnabled ? UIColor.white : UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]))
            button.configuration = config
        }
        self.configurationUpdateHandler = config
    }
    
}

extension UIView {
    
    func addshadow(top: Bool,
                       left: Bool,
                       bottom: Bool,
                       right: Bool,
                       shadowRadius: CGFloat = 2.0) {

            self.layer.masksToBounds = false
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOpacity = 1.0

            let path = UIBezierPath()
            var x: CGFloat = 0
            var y: CGFloat = 0
            var viewWidth = self.frame.width
            var viewHeight = self.frame.height

            // here x, y, viewWidth, and viewHeight can be changed in
            // order to play around with the shadow paths.
            if (!top) {
                y+=(shadowRadius+1)
            }
            if (!bottom) {
                viewHeight-=(shadowRadius+1)
            }
            if (!left) {
                x+=(shadowRadius+1)
            }
            if (!right) {
                viewWidth-=(shadowRadius+1)
            }
            // selecting top most point
            path.move(to: CGPoint(x: x, y: y))
            // Move to the Bottom Left Corner, this will cover left edges
            /*
             |☐
             */
            path.addLine(to: CGPoint(x: x, y: viewHeight))
            // Move to the Bottom Right Corner, this will cover bottom edge
            /*
             ☐
             -
             */
            path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
            // Move to the Top Right Corner, this will cover right edge
            /*
             ☐|
             */
            path.addLine(to: CGPoint(x: viewWidth, y: y))
            // Move back to the initial point, this will cover the top edge
            /*
             _
             ☐
             */
            path.close()
            self.layer.shadowPath = path.cgPath
        }
    
    @discardableResult
    private func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    //addIncomeBtnView.addDashBorder(pattern: [4, 5], radius: 10, color: .clr_primary)
    func addDashBorder(pattern: [NSNumber]?, radius: CGFloat, color: UIColor) {
        DispatchQueue.main.async {
            let dashedBorderLayer = self.addLineDashedStroke(pattern: pattern, radius: radius, color: color.cgColor)
            self.layer.addSublayer(dashedBorderLayer)
        }
    }
    
    func addDashedBorder(linePattern: [NSNumber]? = nil, strokeColor: UIColor = .black, fillSpaceColor: UIColor = .white) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = fillSpaceColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = linePattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func drawDottedLine(color: UIColor = .label) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        let start = CGPoint(x: self.bounds.minX, y: self.bounds.minY)
        let end = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
        path.addLines(between: [start, end])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    /**
           Rotate a view by specified degrees
           parameter angle: angle in degrees
         */

        func rotate(angle: CGFloat) {
            let radians = angle / 180.0 * CGFloat.pi
            let rotation = CGAffineTransformRotate(self.transform, radians);
            self.transform = rotation
        }
    
}

extension UITextField{
    
//    @IBInspectable
//    var placeholderColor: UIColor? {
//        get {
//            if let placeholderColor = self.placeholderColor {
//                attributedPlaceholder = NSAttributedString(
//                    string: placeholder ?? "",
//                    attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
//                )
//                return placeholderColor
//            }
//            else {
//                return nil
//            }
//        }
//        set {
//            attributedPlaceholder = NSAttributedString(
//                string: placeholder ?? "",
//                attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .clr_violet]
//            )
//        }
//    }
    
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }

    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }

    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }

    class func textWidth(font: UIFont, text: String) -> CGFloat {
        return textSize(font: font, text: text).width
    }

    class func textHeight(withWidth width: CGFloat, font: UIFont, text: String) -> CGFloat {
        return textSize(font: font, text: text, width: width).height
    }

    class func textSize(font: UIFont, text: String, extra: CGSize) -> CGSize {
        var size = textSize(font: font, text: text)
        size.width = size.width + extra.width
        size.height = size.height + extra.height
        return size
    }

    class func textSize(font: UIFont, text: String, width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size
    }

    class func countLines(font: UIFont, text: String, width: CGFloat, height: CGFloat = .greatestFiniteMagnitude) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = text as NSString

        let rect = CGSize(width: width, height: height)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }

    func countLines(width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = (self.text ?? "") as NSString

        let rect = CGSize(width: width, height: height)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

extension UIViewController {
    
    func getDarkModeStatus() -> UIUserInterfaceStyle {
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            // light mode detected
            return .light
            
        case .dark:
            // dark mode detected
            return .dark
        @unknown default:
            return .light
        }
        
    }
    
}

extension UIView {
    func getDarkModeStatus() -> UIUserInterfaceStyle {
        
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            // light mode detected
            return .light
            
        case .dark:
            // dark mode detected
            return .dark
        @unknown default:
            return .light
        }
        
    }
}
