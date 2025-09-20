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
    private(set) var isSearchEnabled: Bool = false
    var pageNo: Int = 1
    var pageSize: Int = 25
    private(set) var isLast: Bool = false
    private(set) var isPaginating: Bool = false
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
            isSearchEnabled = true
            eventsListResponse.value?.data?.events = searchedEvents
        }
        else {
            isSearchEnabled = false
            eventsListResponse.value?.data?.events = allEventsList
        }
    }
    
    func eventsListApi(paginate: Bool = false) {
        if paginate {
            pageNo += 1
        }
        var params: [String] = eventParams
        params.append("page=\(pageNo)")
        params.append("limit=\(pageSize)")
        isPaginating = true
        eventsListService.eventsListApi(queryParams: params) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
//                self?.eventsListResponse.value = data
//                self?.allEventsList = data?.data?.events
                self?.addDataToList(data: data)
            case .failure(let error):
                print(error.localizedDescription)
                if let data = self?.eventsListResponse.value {
                    self?.eventsListResponse.value?.message = error.localizedDescription
                }
                else {
                    self?.eventsListResponse.value = MahjongEventsListResponse(success: -1, message: error.localizedDescription, data: nil)
                }
            }
            self?.isPaginating = false
        }
    }
    
    func addDataToList(data: MahjongEventsListResponse?) {
        
        var eventsList: [MahjongEventData] = []
        if let preData = eventsListResponse.value {
            if var events = data?.data?.events {
                events.removeAll { $0.approvalStatus != "approved" }
                let isEmpty = eventsListResponse.value?.data?.events?.isEmpty ?? true
                if isEmpty {
                    eventsListResponse.value?.data?.events = events
                }
                else {
                    eventsListResponse.value?.data?.events?.append(contentsOf: events)
                }
                eventsList.append(contentsOf: events)
            }
            if let allEventsList {
                self.allEventsList?.append(contentsOf: eventsList)
            }
            else {
                self.allEventsList = eventsList
            }
        }
        else {
            if var events = data?.data?.events {
                events.removeAll { $0.approvalStatus != "approved" }
                eventsList.append(contentsOf: events)
            }
            
            var mutableData = data
            mutableData?.data?.events = eventsList
            eventsListResponse.value = mutableData
            
            if let allEventsList {
                self.allEventsList?.append(contentsOf: eventsList)
            }
            else {
                self.allEventsList = eventsList
            }
        }
        
        let isEmpty = data?.data?.events?.isEmpty ?? true
        isLast = (data?.data?.events?.count ?? 0) < 25
        if isEmpty, pageNo > 1 {
            pageNo -= 1
        }
        
    }
    
}
