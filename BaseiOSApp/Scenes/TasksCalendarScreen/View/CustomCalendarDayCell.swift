//
//  CustomCalendarCell.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 14/08/2025.
//

import UIKit

class CustomCalendarDayCell: UICollectionViewCell {
    static let reuseIdentifier = "CustomCalendarDayCell"
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    
    func configure(with date: Date, calendar: Calendar, isSelected: Bool) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EE" // Short weekday
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        dayLabel.text = dayFormatter.string(from: date)
        dateLabel.text = dateFormatter.string(from: date)
        
        if isSelected {
            backgroundColor = .systemRed
            dayLabel.textColor = .white
            dateLabel.textColor = .white
        } else {
            backgroundColor = .clear
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        }
    }
}

