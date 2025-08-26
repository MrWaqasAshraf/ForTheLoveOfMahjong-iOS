//
//  TasksCalendarViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 14/08/2025.
//

import Foundation

class TasksCalendarViewModel {
    
    private let calendar = Calendar.current
    private(set) var dates: Bindable<(Bool, [Date], [Date])> = Bindable((true, [], []))
    var selectedDate: Date?
    
    init(selectedDate: Date? = Date()) {
        self.selectedDate = selectedDate
        generateInitialDates()
    }
    
    private func generateInitialDates() {
        let today = Date()
        let startDate = calendar.date(byAdding: .month, value: -6, to: today)!
        let endDate = calendar.date(byAdding: .month, value: 6, to: today)!
        dates.value?.0 = true
        dates.value?.1 = generateDates(from: startDate, to: endDate)
    }
    
    func generateDates(from start: Date, to end: Date) -> [Date] {
        var days: [Date] = []
        var current = start
        while current <= end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return days
    }
    
    func prependDates() {
        guard let firstDate = dates.value?.1.first else { return }
        let newStart = calendar.date(byAdding: .month, value: -6, to: firstDate)!
        let newDates = generateDates(from: newStart, to: calendar.date(byAdding: .day, value: -1, to: firstDate)!)
        dates.value?.0 = false
        dates.value?.1.insert(contentsOf: newDates, at: 0)
        dates.value?.2 = newDates
    }
    
    func appendDates() {
        guard let lastDate = dates.value?.1.last else { return }
        let newEnd = calendar.date(byAdding: .month, value: 6, to: lastDate)!
        let newDates = generateDates(from: calendar.date(byAdding: .day, value: 1, to: lastDate)!, to: newEnd)
        let startIndex = dates.value?.1.count
        dates.value?.0 = true
        dates.value?.1.append(contentsOf: newDates)
        dates.value?.2 = newDates
    }
    
}
