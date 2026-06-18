//
//  Product.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/26/24.
//

import Foundation
import SwiftData

@Model
final class Product {
    @Attribute(.unique) var id: String
    let isFeatured: Bool
    let bandDisplay: String
    let bandTypeString: String
    let series: String
    let seriesDisplay: String
    let materialDisplay: String
    let materialTypeString: String
    let finishDisplay: String
    let finishTypeString: String
    let bandColorType: String
    let bandColorDisplay: String
    let collection: String
    let collectionType: String
    let image: String
    let desc: String
    var isFavorite: Bool
    
    @Relationship(deleteRule: .cascade)
    var caseSizes: [CaseSize]
    
    @Relationship(deleteRule: .cascade)
    var wristSizes: [WristSize]
    
    @Relationship(deleteRule: .cascade)
    var reviews: [Review] = []
    
    init(product: ProductData) {
        self.id = UUID().uuidString
        self.isFeatured = product.isFeatured
        self.bandDisplay = product.bandDisplay
        self.bandTypeString = product.bandType
        self.series = product.series
        self.seriesDisplay = product.seriesDisplay
        self.materialDisplay = product.materialDisplay
        self.materialTypeString = product.materialType
        self.finishDisplay = product.finishDisplay
        self.finishTypeString = product.finishType
        self.bandColorType = product.bandColorType
        self.bandColorDisplay = product.bandColorDisplay
        self.collection = product.collection
        self.collectionType = product.collectionType
        self.image = product.image
        self.desc = product.description
        self.isFavorite = product.isFavorite
        self.caseSizes = product.caseSizes.map { CaseSize(data: $0) }
        self.wristSizes = product.wristSizes.map { WristSize(data: $0) }
    }
}

extension Product {
    static var `default`: Product {
        Product(product: ProductData.default)
    }
}

extension Product {
    var displayPrice: String {
        if let value = caseSizes.first {
            return "\(value.price)"
        }
        else {
            return "n/a"
        }
    }
    
    var title: String {
        "\(materialDisplay) \(finishDisplay) Case"
    }
    
    var detailTitle: String {
        "\(materialDisplay) \(finishDisplay) Case with \(bandColorDisplay)"
    }
    
    var band: String {
        return "\(image)-l"
    }
    
    var face: String {
        return "\(materialTypeString)-\(finishTypeString)-l"
    }
    
    func createCartProductId(caseSize: String, wristSize: String) -> String {
        return "\(self.id)-\(caseSize)-\(wristSize)-\(self.bandColorType)"
    }
    
    var bandType: ProductBandType {
        return ProductBandType(rawValue: self.bandTypeString) ?? .none
    }
    
    var materialType: ProductMaterial {
        return ProductMaterial(rawValue: self.materialTypeString) ?? .none
    }
    
    var finishType: ProductFinish {
        return ProductFinish(rawValue: self.finishTypeString) ?? .none
    }
    
    var ratingAverage: Float {
        let total = self.reviews
            .map { $0.rating }
            .reduce(0, +)
        
        return total / Float(self.reviews.count)
        
    }
}
