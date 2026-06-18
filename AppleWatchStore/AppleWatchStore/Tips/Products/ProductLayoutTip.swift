//
//  ProductLayoutTip.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/8/24.
//

import Foundation
import TipKit

struct ProductLayoutTip: Tip {
    var title: Text {
        Text("tip.layout.title")
    }
    
    var message: Text {
        Text("tip.layout.message")
            .foregroundStyle(.primary)
    }
    
    var image: Image? {
        Image(systemName: "rectangle.grid.1x2.fill")
    }
    
    var actions: [Action] {
        [
            Tip.Action(id: "next-action",
                       title: String(localized: "tip.layout.action"))
        ]
    }
}
