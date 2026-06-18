//
//  ProductDetail.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/1/24.
//

import Foundation
import SwiftUI
import Observation

enum ProductAppleCzreType: String {
    case add
    case none
}

enum ProductCellularType: String, Identifiable, CaseIterable {
    case none
    case wifiOnly
    case wifiAndCellular
    
    var id: String {
        rawValue
    }
}

@Observable
class ProductDetail {
    var selectedCaseSize: CaseSize?
    var selectedWristSSize: WristSize?
    var selectedGPSCellular: ProductCellularType = .none
    var selectedAppleCare: ProductAppleCzreType = .none
    var hasAddedToCart: Bool = false
    
    static let cellularTypeIds = [
        ProductCellularType.wifiOnly,
        ProductCellularType.wifiAndCellular
    ]
    
    func addToCartCheck() -> Bool {
        if selectedCaseSize != nil &&
            selectedWristSSize != nil &&
            selectedGPSCellular != .none {
            
            return true
        }
        
        return false
    }
}
