//
//  EvenDetailViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 30/08/2025.
//

import Foundation

class EvenDetailViewModel {
    
    var isFavouriteEvent: Bool = false
    private(set) var eventDetail: Bindable<MahjongEventData> = Bindable<MahjongEventData>()
    
    private var workItem: DispatchWorkItem?
    private let customQueue = DispatchQueue(label:"myOwnQueue")
    private var apiDispatchGroup = DispatchGroup()
    
    //For API
    private(set) var favoruiteEventResponse: Bindable<FavouriteInfoResponse> = Bindable<FavouriteInfoResponse>()
    private var eventDetailService: any ServicesDelegate
    private var favouriteMahjongEventService: any ServicesDelegate
    
    init(eventDetail: MahjongEventData? = nil, eventDetailService: any ServicesDelegate = MahjongEventDetailService(), favouriteMahjongEventService: any ServicesDelegate = FavouriteMahjongEventService()) {
        if let eventDetail {
            self.eventDetail.value = eventDetail
        }
        self.eventDetailService = eventDetailService
        self.favouriteMahjongEventService = favouriteMahjongEventService
    }
    
    func toggleFavouriteApi() {
        apiDispatchGroup.enter()
        groupNotifier()
        favouriteMahjongEventService.toggleFavouriteEventApi(eventId: eventDetail.value?.id) { [weak self] result in
            switch result{
            case .success((let data, let json, _)):
                NotificationCenter.default.post(name: .toggleFavourite, object: data?.data)
                self?.favoruiteEventResponse.value = data
//                if let favData = data?.data {
//                    self?.mapFavouriteData(data: favData)
//                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.favoruiteEventResponse.value = FavouriteInfoResponse(success: -1, message: error.localizedDescription, data: nil)
            }
            self?.apiDispatchGroup.leave()
        }
    }
    
    func groupNotifier() {
        apiDispatchGroup.notify(queue: customQueue) { [weak self] in
            if let data = self?.favoruiteEventResponse.value?.data {
                print("Notifier fired")
                self?.mapFavouriteData(data: data)
            }
        }
    }
    
    private func mapFavouriteData(data: FavouriteInfoData) {
        print("value fired")
        var mutableObject = eventDetail.value
        if let eventID = data.eventID, let isFavourited = data.isFavourited, let favouriteCount = data.favouriteCount {
            let isEmpty = mutableObject?.favouritedBy?.isEmpty ?? true
            if isFavourited {
                if isEmpty {
                    mutableObject?.favouritedBy = [appUserData?.userID ?? ""]
                }
                else {
                    mutableObject?.favouritedBy?.append(appUserData?.userID ?? "")
                }
            }
            else {
                mutableObject?.favouritedBy?.removeAll(where: { $0 == appUserData?.userID })
            }
            mutableObject?.favouriteCount = favouriteCount
            
        }
        eventDetail.value = mutableObject
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
