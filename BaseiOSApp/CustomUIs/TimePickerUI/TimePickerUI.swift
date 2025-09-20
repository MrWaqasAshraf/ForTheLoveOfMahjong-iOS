//
//  TimePickerUI.swift
//  student-welfare
//
//  Created by Waqas Ashraf on 26/12/2023.
//

import UIKit

class TimePickerUI: UIView, NibInstantiatable{
    
    typealias buttonAction = (TimePickerUI, Int, String?, Date?) -> Void?
    
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var pickerBgView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    private var action: buttonAction? = nil
    
    @discardableResult
    class func addPickerView(parentView: UIView? = nil, title: String? = nil, minimumTime: Date? = nil, maximumDate: Date? = nil, setInterval: Int = 0, closure: @escaping buttonAction) -> TimePickerUI{
        let pickerView = TimePickerUI.fromNib()
        pickerView.action = closure
        pickerView.datePickerView.minimumDate = minimumTime
        pickerView.datePickerView.maximumDate = maximumDate
        pickerView.titleLbl.text = title ?? "Select Time"
        pickerView.datePickerView.minuteInterval = setInterval
        pickerView.pickerBgView.layer.cornerRadius = 10
        pickerView.datePickerView.locale = Locale.init(identifier: "en")
        let keyWindow = parentView == nil ? UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow } : parentView
        DispatchQueue.main.async {
            pickerView.frame = keyWindow?.bounds ?? .init()
            keyWindow?.addSubview(pickerView)
        }
        return pickerView
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if let action{
            let time = DateManager.convertDateToString(inputDate: datePickerView.date, dateFormat: "HH:mm")
            action(self, 0, "\(time):00", datePickerView.date)
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        if let action{
            action(self, 1, nil, nil)
        }
    }
    
    @IBAction func backgroundBtn(_ sender: Any) {
        if let action{
            action(self, 2, nil, nil)
        }
    }
    
}
