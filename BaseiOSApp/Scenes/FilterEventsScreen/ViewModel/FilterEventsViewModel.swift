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
}

enum EventCategorySlug {
    case all
    case american
    case chinese
    case hongkong
    case richi
    case wrightpetterson
}

class EventAndFilterViewModel {
    
    private(set) var eventTypes: Bindable<[CustomOptionModel]> =  Bindable([.init(title: "All", eventSlug: .all),
                                                        .init(title: "Tournament", eventSlug: .tournament),
                                                        .init(title: "Game", eventSlug: .game)])
    private(set) var eventCategories:  Bindable<[CustomOptionModel]> =  Bindable([.init(title: "All", eventCategorySlug: .all),
                                                             .init(title: "American", eventCategorySlug: .american),
                                                             .init(title: "Chinese", eventCategorySlug: .chinese),
                                                             .init(title: "Hong Kong", eventCategorySlug: .hongkong),
                                                             .init(title: "Riichi", eventCategorySlug: .richi),
                                                             .init(title: "Wright Petterson", eventCategorySlug: .wrightpetterson)])
    
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
        eventCategories.value = mutable
    }
    
}
