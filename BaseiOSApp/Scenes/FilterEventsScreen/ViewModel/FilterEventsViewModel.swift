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
    var type: EventOptionSlug = .noneOption
    
    var dateTime: Date {
        didSet {
            if type == .tournament {
                selectedDateTime = dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - hh:mm a")
            }
        }
    }
    
    var selectedDay: String? = nil
    var startTime: Date? = nil
    var endTime: Date? = nil {
        didSet {
            if type == .game {
                if let start = startTime, let end = endTime, let day = selectedDay, day != "" {
                    selectedDateTime = "\(day) - \(start.convertToDateString(dateFormat: "hh:mm a")) to \(end.convertToDateString(dateFormat: "hh:mm a"))"
                }
            }
        }
    }
    var selectedDateTime: String?
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
                                                             .init(title: "Wright Patterson", eventCategorySlug: .wrightpetterson)])
    var selectedEventType: Bindable<CustomOptionModel> = Bindable()
    var selectedCategoryType: Bindable<CustomOptionModel> = Bindable()
    var selectedEventDayAndTimeForGame: Bindable<SelectedEventDateTime> = Bindable<SelectedEventDateTime>()
    
    //For Api integration
    private(set) var eventDetailForEdit: MahjongEventData? = nil
    var eventLocationCoordinates: EventLocationInfo? = nil
    var imageUrls: [URL]?
    var selectedEventDates: Bindable<[SelectedEventDateTime]> = Bindable([])
    private(set) var manageEventResponse: Bindable<GeneralResponse> = Bindable<GeneralResponse>()
    //MahjongEventDetailService
    
    private var manageMahjongEventsService: any ServicesDelegate
    private var mahjongEventDetailService: any ServicesDelegate
    
    init(
        eventDetailForEdit: MahjongEventData? = nil,
        preSelectTypeAndCategory: Bool = false,
        selectedEventType: CustomOptionModel? = nil,
        selectedCategoryType: CustomOptionModel? = nil,
        manageMahjongEventsService: any ServicesDelegate = ManageMahjongEventsService(),
        mahjongEventDetailService: any ServicesDelegate = MahjongEventDetailService()
    ) {
        
        self.eventDetailForEdit = eventDetailForEdit
        self.manageMahjongEventsService = manageMahjongEventsService
        self.mahjongEventDetailService = mahjongEventDetailService
        
        if let eventDetailForEdit {
            
            if let address = eventDetailForEdit.address, let lat = eventDetailForEdit.lat, let lng = eventDetailForEdit.lng {
                eventLocationCoordinates = EventLocationInfo(lat: lat, long: lng, address: address)
            }
            
//            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                if let selectedTypeIndex = self.eventTypes.value?.indices.filter({ self.eventTypes.value?[$0].title == eventDetailForEdit.type }).first as? Int {
                    self.selectedEventType.value = self.eventTypes.value?[selectedTypeIndex]
                    self.eventTypes.value?[selectedTypeIndex].isSelected = true
                }
                if let selectedCategoryIndex = self.eventCategories.value?.indices.filter({ self.eventCategories.value?[$0].title == eventDetailForEdit.category }).first as? Int {
                    self.selectedCategoryType.value = self.eventCategories.value?[selectedCategoryIndex]
                    self.eventCategories.value?[selectedCategoryIndex].isSelected = true
                }
//            }
            
            let selectedDates = eventDetailForEdit.dateTime?.map({ model in
                let selected = SelectedEventDateTime(type: selectedEventType?.eventSlug ?? .noneOption, dateTime: Date(), selectedDay: nil, startTime: nil, endTime: nil, selectedDateTime: model)
                return selected
            })
            
            selectedEventDates.value = selectedDates
            
        }
        else {
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
        
        
    }
    
    func createAndValidatePayload(name: String?, contactName: String?, locationName: String?, address: String?, contact: String?, description: String = "") -> (Bool, String?, [String: Any]) {
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
        
        if let contactName, contactName.count > 2 {
            payload.updateValue(contactName, forKey: "person_name")
        }
        else {
            isValid = false
            validationMessage += "Valid Contact Person Name, "
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
            
            if let eventDetailForEdit {
                var selectedDateTimes: [String] = /*eventDetailForEdit.dateTime ?? */[]
                if selectedEventType.eventSlug == .tournament {
                    if let dates = selectedEventDates.value?.map({ return /*$0.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - HH:mm a")*/ $0.selectedDateTime  }).compactMap({ $0 }) {
                        selectedDateTimes.append(contentsOf: dates)
                        payload.updateValue(selectedDateTimes, forKey: "dateTime")
                    }
                    else {
                        isValid = false
                        validationMessage += "Event Date, "
                    }
                }
                else if selectedEventType.eventSlug == .game {
                    if let dates = selectedEventDates.value?.map({ model in
                        
                        var returnDate: String? = model.selectedDateTime
                        
//                        if let start = model.startTime, let end = model.endTime, let day = model.selectedDay, day != "" {
//                            let startTime = start.convertToDateString(dateFormat: "HH:mm a")
//                            let endTime = end.convertToDateString(dateFormat: "HH:mm a")
//                            returnDate = "\(day) - \(startTime) to \(endTime)"
//                        }
                        
                        return returnDate
                        
                    }).compactMap({ $0 }), !dates.isEmpty {
                        selectedDateTimes.append(contentsOf: dates)
                        payload.updateValue(selectedDateTimes, forKey: "dateTime")
                    }
                    else {
                        isValid = false
                        validationMessage += "Event Date, "
                    }
                }
            }
            else {
                if selectedEventType.eventSlug == .tournament {
                    if let dates = selectedEventDates.value?.map({ return /*$0.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - HH:mm a")*/ $0.selectedDateTime  }).compactMap({ $0 }) {
                        payload.updateValue(dates, forKey: "dateTime")
                    }
                    else {
                        isValid = false
                        validationMessage += "Event Date, "
                    }
                }
                else if selectedEventType.eventSlug == .game {
                    if let dates = selectedEventDates.value?.map({ model in
                        
                        var returnDate: String? = model.selectedDateTime
                        
//                        if let start = model.startTime, let end = model.endTime, let day = model.selectedDay, day != "" {
//                            let startTime = start.convertToDateString(dateFormat: "HH:mm a")
//                            let endTime = end.convertToDateString(dateFormat: "HH:mm a")
//                            returnDate = "\(day) - \(startTime) to \(endTime)"
//                        }
                        
                        return returnDate
                        
                    }).compactMap({ $0 }), !dates.isEmpty {
                        payload.updateValue(dates, forKey: "dateTime")
                    }
                    else {
                        isValid = false
                        validationMessage += "Event Date, "
                    }
                }
                else {
                    isValid = false
                    validationMessage += "Event Type, "
                }
            }
            
            
            
            
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
    
    private func getEventDetailApi() {
        mahjongEventDetailService.mahjongEventDetailApi(eventId: eventDetailForEdit?.id) { result in
            switch result {
            case .success((let data, let json, let resp)):
                if let eventData = data?.data?.event {
                    if eventData.approvalStatus == "approved" {
                        NotificationCenter.default.post(name: .eventAdded, object: eventData)
                    }
                    NotificationCenter.default.post(name: .eventDetail, object: eventData)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createMahjonEventApi(parameters: [String: Any]?) {
        
        if let eventDetailForEdit {
            manageMahjongEventsService.updateEventApi(parameters: parameters, images: nil, eventId: eventDetailForEdit.id) { [weak self] result in
                switch result {
                case .success((let data, let json, let resp)):
                    self?.manageEventResponse.value = data
                    if data?.isSuccessful == true {
                        self?.getEventDetailApi()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.manageEventResponse.value = GeneralResponse(success: -1, message: error.localizedDescription)
                }
            }
        }
        else {
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
        
    }
    
    func compileSelectedDatesForLabel() -> String {
        var selectedDatesString: String = ""
        if let selectedDates = selectedEventDates.value {
            for selectedDate in selectedDates {
                let connectingString: String = selectedDatesString.isEmpty ? "" : "\n"
                if selectedEventType.value?.eventSlug == .tournament {
//                    selectedDatesString += "\(connectingString)\(selectedDate.dateTime.convertToDateString(dateFormat: "EEEE, MMMM dd, yyyy - hh:mm a"))"
                    selectedDatesString += "\(connectingString)\(selectedDate.selectedDateTime ?? "")"
                }
                else if selectedEventType.value?.eventSlug == .game {
//                    if let start = selectedDate.startTime, let end = selectedDate.endTime, let day = selectedDate.selectedDay, day != "" {
//                        selectedDatesString += "\(connectingString)\(day) - \(start.convertToDateString(dateFormat: "hh:mm a")) to \(end.convertToDateString(dateFormat: "hh:mm a"))"
//                    }
                    selectedDatesString += "\(connectingString)\(selectedDate.selectedDateTime ?? "")"
                }
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
        
        //Old
        /*
         if selectedEventType.value?.eventSlug == .game {
             if let item = selectedEventDates.value?.first {
                 selectedEventDates.value = [item]
             }
         }
         */
        
        //New
        selectedEventDates.value = []
        eventDetailForEdit?.dateTime = []
        
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
