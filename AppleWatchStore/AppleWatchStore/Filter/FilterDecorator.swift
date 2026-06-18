//
//  FilterDecorator.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/30/24.
//

import Foundation

protocol ProductWatchFilter {
    func filter(products: [Product], by specs: [ProductSpecs]) -> [Product]
}

class ProductBaseFilter: ProductWatchFilter {
    func filter(products: [Product], by specs: [ProductSpecs]) -> [Product] {
        return products
    }
}

class ProductFilterDecorator: ProductWatchFilter {
    private let productFilter: ProductWatchFilter
    
    init(productFilter: ProductWatchFilter) {
        self.productFilter = productFilter
    }
    
    func filter(products: [Product], by specs: [ProductSpecs]) -> [Product] {
        return productFilter.filter(products: products, by: specs)
    }
}

final class ProductMaterialFilter: ProductFilterDecorator {
    override func filter(products: [Product], by specs: [ProductSpecs]) -> [Product] {
        let filter = Filter(strategy: MaterialFilter())
        let appliedFilterResult = super.filter(products: products, by: specs)
        let filteredProducts = filter.applyFilter(to: appliedFilterResult, withSpecs: specs)
        
        return filteredProducts
    }
}

final class ProductFinishFilter: ProductFilterDecorator {
    override func filter(products: [Product], by specs: [ProductSpecs]) -> [Product] {
        let filter = Filter(strategy: FinishFilter())
        let appliedFilterResult = super.filter(products: products, by: specs)
        let filteredProducts = filter.applyFilter(to: appliedFilterResult, withSpecs: specs)
        
        return filteredProducts
    }
}

final class ProductBandFilter: ProductFilterDecorator {
    override func filter(products: [Product], by specs: [ProductSpecs]) -> [Product] {
        let filter = Filter(strategy: BandFilter())
        let appliedFilterResult = super.filter(products: products, by: specs)
        let filteredProducts = filter.applyFilter(to: appliedFilterResult, withSpecs: specs)
        
        return filteredProducts
    }
}
