//
//  WristSize.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/26/24.
//

import Foundation
import SwiftData

@Model
class WristSize {
    @Attribute(.unique) var id: String
    var size: String
    var desc: String
    var order: Int
    
    init(data: WristSizeData) {
        self.id = UUID().uuidString
        self.size = data.size
        self.desc = data.description
        self.order = data.order
    }
}

extension WristSize {
    static var `default`: WristSize {
        WristSize(data: WristSizeData.default)
    }
}
