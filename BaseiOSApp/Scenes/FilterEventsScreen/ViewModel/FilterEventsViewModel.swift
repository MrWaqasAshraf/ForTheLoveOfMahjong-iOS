//
//  FilterEventsViewModel.swift
//  BaseiOSApp
//
//  Created by Waqas Ashraf on 26/08/2025.
//

import Foundation

struct CustomOptionModel {
    var title: String = ""
    var isSelected: Bool = false
    var eventSlug: EventOptionSlug? = nil
    var eventCategorySlug: EventCategorySlug? = nil
}

enum EventOptionSlug {
    case all
    case tournament
    case game
    case noneOption
}

enum EventCategorySlug {
    case all
    case american
    case chinese
    case hongkong
    case richi
    case wrightpetterson
}

struct SelectedEventDateTime {
    var dateTime: Date
}

struct EventLocationInfo {
    var lat: Double
    var long: Double
    var address: String
}

class EventAndFilterViewModel {
    
    //For UI
    private(set) var eventTypes: Bindable<[CustomOptionModel]> =  Bindable([.init(title: "All", eventSlug: .all),
                                                                            .init(title: "Tournament", eventSlug: .tournament),
                                                        .init(title: "Game", eventSlug: .game)])
    private(set) var eventCategories:  Bindable<[CustomOptionModel]> =  Bindable([.init(title: "All", eventCategorySlug: .all),
                                                                                  .init(title: "American", eventCategorySlug: .american),
                                                             .init(title: "Chinese", eventCategorySlug: .chinese),
                                                             .init(title: "Hong Kong", eventCategorySlug: .hongkong),
                                                             .init(title: "Riichi", eventCategorySlug: .richi),
                                                             .init(title: "Wright Petterson", eventCategorySlug: .wrightpetterson)])
    var selectedEventType: Bindable<CustomOptionModel> = Bindable()
    var selectedCategoryType: Bindable<CustomOptionModel> = Bindable()
    
    //For Api integration
    var eventLocationCoordinates: EventLocationInfo? = nil
    var imageUrls: [URL]?
    var selectedEventDates: Bindable<[SelectedEventDateTime]> = Bindable([])
    private(set) var manageEventResponse: Bindable<GeneralResponse> = Bindable<GeneralResponse>()
    
    private var manageMahjongEventsService: any ServicesDelegate
    
    init(
        preSelectTypeAndCategory: Bool = false,
        selectedEventType: CustomOptionModel? = nil,
        selectedCategoryType: CustomOptionModel? = nil,
        manageMahjongEventsService: any ServicesDelegate = ManageMahjongEventsService()
    ) {
        
        self.manageMahjongEventsService = manageMahjongEventsService
        
        if preSelectTypeAndCategory {
            if let index = eventTypes.value?.indices.filter({ eventTypes.value?[$0].eventSlug == .tournament }).first as? Int {
                eventTypes.value?[index].isSelected = true
                self.selectedEventType.value = eventTypes.value?[index]
            }
            if let index = eventCategories.value?.indices.filter({ eventCategories.value?[$0].eventCategorySlug == .american }).first as? Int {
                eventCategories.value?[index].isSelected = true
                self.selectedCategoryType.value = eventCategories.value?[index]
            }
        }
        else {
            if let selectedType = selectedEventType, let slug = selectedType.eventSlug {
                if let index = eventTypes.value?.indices.filter({ eventTypes.value?[$0].eventSlug == slug }).first as? Int {
                    eventTypes.value?[index].isSelected = true
                }
            }
            if let selectedCategory = selectedCategoryType, let slug = selectedCategory.eventCategorySlug {
                if let index = eventCategories.value?.indices.filter({ eventCategories.value?[$0].eventCategorySlug == slug }).first as? Int {
                    eventCategories.value?[index].isSelected = true
                }
            }
        }
        
    }
    
    func createAndValidatePayload(name: String?, locationName: String?, address: String?, contact: String?, description: String = "") -> (Bool, String?, [String: Any]) {
        /*
         {
         "type":"Tournament",
         "name":"Annual Mahjong Championship 2025",
         "dateTime":["Saturday, March 15, 2025 – 10:00 AM", "Saturday, March 15, 2025 – 06:00 PM"],
         "locationName":"Grand Mahjong Hall",
         "address":"123 Tournament Street, Mahjong City, MC 12345",
         "lat":40.7589,
         "lng":-73.9851,
         "category":"Chinese",
         "contact":"+1-555-MAHJONG",
         "description":"Join us for the most exciting Mahjong tournament of the year! Open to all skill levels with multiple prize categories. Professional dealers and equipment provided.",
         }
         */
        var isValid: Bool = true
        var validationMessage: String = ""
        var payload: [String: Any] = ["description": description]
        if let name, name.count > 2 {
            payload.updateValue(name, forKey: "name")
        }
        else {
            isValid = false
            validationMessage += "Valid Event Name, "
        }
        
        if let locationName, locationName.count > 2 {
            payload.updateValue(locationName, forKey: "locationName")
        }
        else {
            isValid = false
            validationMessage += "Valid Location Name, "
        }
        
        if let contact, contact.count > 0 {
            payload.updateValue(contact, forKey: "contact")
        }
        else {
            isValid = false
            validationMessage += "Valid Contact, "
        }
        
        if let selectedEventType = selectedEventType.value {
            payload.updateValue(selectedEventType.title, forKey: "type")
        }
        else {
            isValid = false
            validationMessage += "Event Type, "
        }
        
        if let selectedCategoryType = selectedCategoryType.value {
            payload.updateValue(selectedCategoryType.title, forKey: "category")
        }
        else {
            isValid = false
            validationMessage += "Event Category, "
        }
        
        if let dates = selectedEventDates.value?.map({ return $0.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - HH:mm a") }) {
            payload.updateValue(dates, forKey: "dateTime")
        }
        else {
            isValid = false
            validationMessage += "Event Date, "
        }
        
        if let eventLocationCoordinates {
            //"lat":40.7589, "lng":-73.9851
            let lat = eventLocationCoordinates.lat
            let long = eventLocationCoordinates.long
            payload.updateValue(lat, forKey: "lat")
            payload.updateValue(long, forKey: "lng")
            payload.updateValue(eventLocationCoordinates.address, forKey: "address")
        }
        else {
            isValid = false
            validationMessage += "Event Address, "
        }
        
        if !validationMessage.isEmpty, validationMessage.count > 2 {
            validationMessage = String(validationMessage.dropLast(2))
            validationMessage += " Required"
        }
        
        return (isValid, validationMessage, payload)
    }
    
    func createMahjonEventApi(parameters: [String: Any]?) {
        manageMahjongEventsService.createEventApi(parameters: parameters, images: imageUrls) { [weak self] result in
            switch result {
            case .success((let data, let json, let resp)):
                self?.manageEventResponse.value = data
            case .failure(let error):
                print(error.localizedDescription)
                self?.manageEventResponse.value = GeneralResponse(success: -1, message: error.localizedDescription)
            }
        }
    }
    
    func compileSelectedDatesForLabel() -> String {
        var selectedDatesString: String = ""
        if let selectedDates = selectedEventDates.value {
            for selectedDate in selectedDates {
                let connectingString: String = selectedDatesString.isEmpty ? "" : "\n"
                selectedDatesString += "\(connectingString)\(selectedDate.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - hh:mm a"))"
            }
        }
        return selectedDatesString
    }
    
    func addSelectedDates(date: SelectedEventDateTime) {
        let eventType = selectedEventType.value
        if eventType?.eventSlug == .tournament {
            selectedEventDates.value?.append(date)
        }
        else if eventType?.eventSlug == .game {
            selectedEventDates.value = [date]
        }
    }
    
    func shouldSelectEventType(indexPath: IndexPath) {
        var mutable = eventTypes.value
        for (index, item) in (mutable ?? []).enumerated() {
            if index == indexPath.item {
                mutable?[index].isSelected = !item.isSelected
            }
            else {
                mutable?[index].isSelected = false
            }
        }
        if let selectedEvent = mutable?.filter({ $0.isSelected == true }).first {
            selectedEventType.value = selectedEvent
        }
        else {
            selectedEventType.value = nil
        }
        if selectedEventType.value?.eventSlug == .game {
            if let item = selectedEventDates.value?.first {
                selectedEventDates.value = [item]
            }
        }
        eventTypes.value = mutable
    }
    
    func shouldSelectEventCategory(indexPath: IndexPath) {
        var mutable = eventCategories.value
        for (index, item) in (mutable ?? []).enumerated() {
            if index == indexPath.item {
                mutable?[index].isSelected = !item.isSelected
            }
            else {
                mutable?[index].isSelected = false
            }
        }
        if let selectedCategory = mutable?.filter({ $0.isSelected == true }).first {
            selectedCategoryType.value = selectedCategory
        }
        else {
            selectedCategoryType.value = nil
        }
        
        eventCategories.value = mutable
    }
    
}
