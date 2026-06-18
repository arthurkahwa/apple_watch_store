//
//  ProductFilterTip.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/8/24.
//

import Foundation
import TipKit

struct ProductFilterTip: Tip {
    static let productSteps: Event = Event<Tips.EmptyDonation>(id: "tip.event.product-steps")
    
    public var title: Text {
        Text("tip.filter.title")
    }
    
    public var message: Text {
        Text("tip.filter.message")
            .foregroundStyle(.primary)
    }
    
    public var image: Image? {
        Image(systemName: "slider.horizontal.3")
    }
    
    public var actions: [Action] {
        [
            Action(id: "action.title.dismiss",
                   title: String(localized: "tip.filter.action"))
        ]
    }
    
    public var rules: [Rule] {
        #Rule(Self.productSteps) { $0.donations.count == 1 }
    }
    
    public var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
    
}
