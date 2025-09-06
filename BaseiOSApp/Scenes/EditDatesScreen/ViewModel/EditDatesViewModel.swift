//
//  EditDatesViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 06/09/2025.
//

import Foundation

class EditDatesViewModel {
    
    private(set) var selectedDates: Bindable<[SelectedEventDateTime]> = Bindable([])
    
    init(selectedDates: [SelectedEventDateTime]? = nil) {
        if let selectedDates {
            self.selectedDates.value = selectedDates
        }
    }
    
    func removeDate(indexPath: IndexPath) {
        selectedDates.value?.remove(at: indexPath.row)
    }
    
}
