//
//  EvenDetailViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import Foundation

class EvenDetailViewModel {
    
    private(set) var eventDetail: Bindable<MahjongEventData> = Bindable<MahjongEventData>()
    
    //For API
    private var eventDetailService: any ServicesDelegate
    
    init(eventDetail: MahjongEventData? = nil, eventDetailService: any ServicesDelegate = MahjongEventDetailService()) {
        if let eventDetail {
            self.eventDetail.value = eventDetail
        }
        self.eventDetailService = eventDetailService
    }
    
    func mahjongEventDetailApi() {
        eventDetailService.mahjongEventDetailApi(eventId: eventDetail.value?.id) { [weak self] result in
            switch result{
            case .success((let data, let json, _)):
                self?.eventDetail.value = data?.data?.event
            case .failure(let error):
                print(error.localizedDescription)
                if let eventDetail = self?.eventDetail.value {
                    self?.eventDetail.value = eventDetail
                }
                
            }
        }
    }
    
}
