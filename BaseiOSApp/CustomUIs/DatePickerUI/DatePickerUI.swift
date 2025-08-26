//
//  DatePickerUI.swift
//  student-welfare
//
//  Created by Waqas Ashraf on 26/12/2023.
//

import UIKit

class DatePickerUI: UIView, NibInstantiatable{
    
    typealias buttonAction = (DatePickerUI, Int, String?, Date?) -> Void?
    @IBOutlet weak var pickerBgView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    var outputDateFormat: String = "yyyy-MM-dd"
    private var action: buttonAction? = nil
    
    @discardableResult
    class func addPickerView(parentView: UIView? = nil, datePickerMode: UIDatePicker.Mode? = nil, minimumTime: Date? = nil, outputDateFormat: String? = nil, closure: @escaping buttonAction) -> DatePickerUI{
        let dateUi = DatePickerUI.fromNib()
        dateUi.action = closure
        if let outputDateFormat{
            dateUi.outputDateFormat = outputDateFormat
        }
        if #available(iOS 14.0, *) {
            dateUi.datePickerView.preferredDatePickerStyle = .inline
        } else if #available(iOS 13.4, *){
            // Fallback on earlier versions
            dateUi.datePickerView.preferredDatePickerStyle = .wheels
        }
        if let datePickerMode {
            dateUi.datePickerView.datePickerMode = datePickerMode
        }
        dateUi.datePickerView.minimumDate = minimumTime
        dateUi.pickerBgView.layer.cornerRadius = 10
        let keyWindow = parentView == nil ? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow } : parentView
        DispatchQueue.main.async {
            dateUi.frame = keyWindow?.bounds ?? .init()
            keyWindow?.addSubview(dateUi)
        }
        return dateUi
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        if let action{
            action(self, 1, nil, nil)
        }
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if let action{
            let date = DateManager.convertDateToString(inputDate: datePickerView.date, dateFormat: outputDateFormat)
            action(self, 0, date, datePickerView.date)
        }
    }
    
    @IBAction func backgroundBtn(_ sender: Any) {
        if let action{
            action(self, 2, nil, nil)
        }
    }
    
}
