//
//  ProductFilterData.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/24/24.
//

import Foundation

class ProductFilterData: Codable {
    let id: String
    let category: String
    let categoryOrder: Int
    let order: Int
    let title: String
    let type: String
    let isSelected: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case category
        case categoryOrder = "category-order"
        case order
        case title
        case type
        case isSelected
    }
    
    init(id: String, category: String, categoryOrder: Int, order: Int, title: String, type: String, isSelected: Bool) {
        self.id = id
        self.category = category
        self.categoryOrder = categoryOrder
        self.order = order
        self.title = title
        self.type = type
        self.isSelected = isSelected
    }
}

extension ProductFilterData {
    static var `default`: ProductFilterData {
        ProductFilterData(id: "material-aluminum",
                          category: "material",
                          categoryOrder: 2,
                          order: 2,
                          title: "Aluminum",
                          type: "aluminum",
                          isSelected: false)
    }
}
