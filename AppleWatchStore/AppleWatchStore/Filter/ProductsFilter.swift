//
//  ProductsFilter.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/30/24.
//

import Foundation
import Combine
import SwiftData

@Observable
class ProductsFilter {
    var productFilterSpecs = [ProductSpecs]()
    
    func fetchSaved(filters: [ProductFilter]) {
        productFilterSpecs.removeAll()
        
        filters.forEach { filter in
            if filter.isSelected {
                add(spec: filter.spec)
            }
        }
    }
    
    var filterCount: Int {
        productFilterSpecs.count
    }
    
    func clearAll() {
        productFilterSpecs.removeAll()
    }
    
    func add(spec: ProductSpecs) {
        productFilterSpecs.append(spec)
    }
    
    func remove(spec: ProductSpecs) {
        guard let index = productFilterSpecs.firstIndex(where: { $0 == spec })
        else { preconditionFailure("Error") }
        
        productFilterSpecs.remove(at: index)
    }
    
    func filterProducts(products: [Product]) -> [Product] {
        let materialFilter = ProductMaterialFilter(productFilter: ProductBaseFilter())
        let finishFilter = ProductFinishFilter(productFilter: materialFilter)
        let bandFilter = ProductBandFilter(productFilter: finishFilter)
        
        let filteredProducts = bandFilter.filter(products: products,
                                                 by: productFilterSpecs)
        
        return filteredProducts
    }
}
