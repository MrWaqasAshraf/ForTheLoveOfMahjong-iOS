//
//  EvenDetailViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import Foundation

class EvenDetailViewModel {
    
    private(set) var eventDetail: Bindable<MahjongEventData> = Bindable<MahjongEventData>()
    
    init(eventDetail: MahjongEventData? = nil) {
        if let eventDetail {
            self.eventDetail.value = eventDetail
        }
    }
    
}
