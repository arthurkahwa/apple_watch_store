//
//  WristSizeData.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

class WristSizeData: Identifiable, Codable {
    var id = UUID().uuidString
    var size: String = ""
    var description: String = ""
    var order: Int = 0
    
    init(id: String = UUID().uuidString, size: String, description: String, order: Int) {
        self.id = id
        self.size = size
        self.description = description
        self.order = order
    }
    
    static var `default`: WristSizeData {
        WristSizeData(size: "S/M", description: "Band fits 130mm-180mm wrist", order: 1)
    }
}
