//
//  CaseSizeData.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

class CaseSizeData: Identifiable, Codable {
    var id = UUID().uuidString
    var size: String = ""
    var description: String = ""
    var price: String = ""
    var amount: Float = 0.0
    var order: Int = 0
    
    init(id: String = UUID().uuidString, size: String, description: String, price: String, amount: Float, order: Int) {
        self.id = id
        self.size = size
        self.description = description
        self.price = price
        self.amount = amount
        self.order = order
    }
}

extension CaseSizeData {
    static var `default`: CaseSizeData {
        CaseSizeData(size: "65mm", description: "Fits 140-220mm wrists", price: "279", amount: 2.79, order: 1)
    }
}
