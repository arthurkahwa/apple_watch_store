//
//  CartProduct.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/1/24.
//

import Foundation
import SwiftUI

class CartProduct: Identifiable {
    var id: String
    var image: String
    var name: String
    var price: Float
    var productSeries: String
    var displayPrice: String
    var quantity: Int
    var description: String
    var bandName: String
    var bandColor: String
    var caseMaterial: String
    var caseFinish: String
    var caseSize: String
    var caseSizeId: String
    var caseAmount: Float
    var wristSize: String
    var wristSizeId: String
    var cellularType: ProductCellularType
    
    init(product: Product, caseSize: CaseSize, wristSize: WristSize, cellularType: ProductCellularType, quantity: Int) {
        self.name = product.seriesDisplay
        self.image = product.image
        self.price = Float(caseSize.amount)
        self.productSeries = product.seriesDisplay
        self.displayPrice = String(caseSize.amount.formatted(FloatingPointFormatStyle()))
        self.quantity = quantity
        self.description = product.desc
        self.bandName = product.bandType.rawValue
        self.bandColor = product.bandColorDisplay
        self.caseMaterial = product.materialDisplay
        self.caseFinish = product.finishDisplay
        self.caseSize = caseSize.size
        self.caseSizeId = caseSize.id
        self.caseAmount = Float(caseSize.amount)
        self.wristSize = wristSize.size
        self.wristSizeId = wristSize.id
        self.cellularType = cellularType
        
        let wrist = self.wristSize.replacingOccurrences(of: " ", with: "")
        
        self.id = product.createCartProductId(caseSize: self.caseSize, wristSize: wrist).lowercased()
    }
    
    var band: String {
        return "\(image)-l"
    }
    
    var face: String {
        return "\(caseMaterial.lowercased())-\(caseFinish.lowercased())-l"
    }
    
    static var `default`: CartProduct {
        CartProduct(product: Product.default,
                    caseSize: CaseSize.default,
                    wristSize: WristSize.default,
                    cellularType: ProductCellularType.wifiAndCellular,
                    quantity: 2)
    }
}
