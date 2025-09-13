//
//  EventsListViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 13/09/2025.
//

import Foundation

enum EventsListType: String {
    
    case allEvents = ""
    case favourites = "favouritesOnly"
    case noneType = "none"
    
}

class EventsListViewModel {
    
    //For UI
    var screenTitle: String
    var eventsListType: EventsListType
    
    //For API
    private var eventParams: [String] {
        var params: [String] = []
        if eventsListType == .favourites {
            params.append("favouritesOnly=true")
        }
        return params
    }
    private var allEventsList: [MahjongEventData]?
    private(set) var eventsListResponse: Bindable<MahjongEventsListResponse> = Bindable<MahjongEventsListResponse>()
    private var eventsListService: any ServicesDelegate
    
    init(screenTitle: String = "", eventsListType: EventsListType = .noneType, eventsListService: any ServicesDelegate = EventsListingService()) {
        self.screenTitle = screenTitle
        self.eventsListType = eventsListType
        self.eventsListService = eventsListService
    }
    
    func searchEvents(searchText: String?) {
        if let searchText, !searchText.replacingOccurrences(of: " ", with: "").isEmpty {
            let searchedEvents = allEventsList?.filter({
                $0.name?.lowercased().contains(searchText.lowercased()) == true ||
                $0.locationName?.lowercased().contains(searchText.lowercased()) == true ||
                $0.address?.lowercased().contains(searchText.lowercased()) == true ||
                $0.type?.lowercased().contains(searchText.lowercased()) == true ||
                $0.category?.lowercased().contains(searchText.lowercased()) == true ||
                $0.contact?.lowercased().contains(searchText.lowercased()) == true ||
                $0.dateTime?.filter({ $0.lowercased().contains(searchText.lowercased()) == true }).first?.lowercased().contains(searchText.lowercased()) == true
            })
            eventsListResponse.value?.data?.events = searchedEvents
        }
        else {
            eventsListResponse.value?.data?.events = allEventsList
        }
    }
    
    func eventsListApi() {
        eventsListService.eventsListApi(queryParams: eventParams) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.eventsListResponse.value = data
                self?.allEventsList = data?.data?.events
            case .failure(let error):
                print(error.localizedDescription)
                self?.eventsListResponse.value = MahjongEventsListResponse(success: -1, message: error.localizedDescription, data: nil)
                self?.allEventsList = nil
            }
        }
    }
    
}
