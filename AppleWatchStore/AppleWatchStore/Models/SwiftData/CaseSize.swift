//
//  CaseSize.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/26/24.
//

import Foundation
import SwiftData

@Model
final class CaseSize {
    @Attribute(.unique) var id: String
    var size: String
    var desc: String
    var price: String
    var amount: Double
    var order: Int
    
    init(data: CaseSizeData) {
        self.id = UUID().uuidString
        self.size = data.size
        self.desc = data.description
        self.price = data.price
        self.amount = Double(data.amount)
        self.order = data.order
    }
}

extension CaseSize {
    static var `default`: CaseSize {
        CaseSize(data: CaseSizeData.default)
    }
}
