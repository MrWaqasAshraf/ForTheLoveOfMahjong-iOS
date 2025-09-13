//
//  MainMapViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import Foundation

class MainMapViewModel {
    
    //For API
    var selectedEventType: CustomOptionModel?
    var selectedCategoryType: CustomOptionModel?
    private(set) var dashboardResponse: Bindable<MahjongEventsListResponse> = Bindable<MahjongEventsListResponse>()
    private var dashbaordService: any ServicesDelegate
    
    init(dashbaordService: any ServicesDelegate = EventsListingService()) {
        self.dashbaordService = dashbaordService
    }
    
    func dashboardApi() {
        var filters: [String] = []
        if let selectedEventType, selectedEventType.eventSlug != .all {
            filters.append("type=\(selectedEventType.title)")
        }
        if let selectedCategoryType, selectedCategoryType.eventCategorySlug != .all {
            filters.append("category=\(selectedCategoryType.title)")
        }
        dashbaordService.dashboardEventsApi(filters: filters) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.dashboardResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.dashboardResponse.value = MahjongEventsListResponse(success: -1, message: error.localizedDescription, data: nil)
            }
        }
        
    }
    
    func observeFavouriteNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(mapFavouriteData), name: .toggleFavourite, object: nil)
    }
    
    @objc
    private func mapFavouriteData(notify: Notification) {
        if let data = notify.object as? FavouriteInfoData {
            var mutableObject = dashboardResponse.value
            for (index, var eventItem) in (mutableObject?.data?.events ?? []).enumerated() {
                if let eventID = data.eventID, let isFavourited = data.isFavourited, let favouriteCount = data.favouriteCount {
                    let isEmpty = eventItem.favouritedBy?.isEmpty ?? true
                    if isFavourited {
                        if isEmpty {
                            eventItem.favouritedBy = [appUserData?.userID ?? ""]
                        }
                        else {
                            eventItem.favouritedBy?.append(appUserData?.userID ?? "")
                        }
                    }
                    else {
                        eventItem.favouritedBy?.removeAll(where: { $0 == appUserData?.userID })
                    }
                    eventItem.favouriteCount = favouriteCount
                    mutableObject?.data?.events?[index] = eventItem
                }
            }
            dashboardResponse.value = mutableObject
        }
        
    }
    
}
