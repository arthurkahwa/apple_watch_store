//
//  ProductFilter.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/26/24.
//

import Foundation
import SwiftData

@Model
final class ProductFilter {
    @Attribute(.unique)
    var id: String
    var category: String
    var categoryOrder: Int
    var order: Int
    var title: String
    var type: String
    var isSelected: Bool
    
    init(filter: ProductFilterData) {
        self.id = UUID().uuidString
        self.category = filter.category
        self.categoryOrder = filter.categoryOrder
        self.order = filter.order
        self.title = filter.title
        self.type = filter.type
        self.isSelected = filter.isSelected
    }
}

extension ProductFilter {
    static var `default`: ProductFilter {
        ProductFilter(filter: ProductFilterData.default)
    }
}

extension ProductFilter {
    var spec: ProductSpecs {
        if category == "material" {
            return ProductSpecs.material(ProductMaterial(rawValue: type) ?? .none)
        }
        else if category == "band" {
            return ProductSpecs.band(ProductBandType(rawValue: type) ?? .none)
        }
        else {
            return ProductSpecs.finish(ProductFinish(rawValue: type) ?? .none)
        }
    }
}
