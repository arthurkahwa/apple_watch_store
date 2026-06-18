//
//  ProductSpecs.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/29/24.
//

import Foundation

enum ProductSpecs: Equatable {
    case material(ProductMaterial)
    case finish(ProductFinish)
    case band(ProductBandType)
    case none
}

enum ProductMaterial: String, Hashable, CaseIterable {
    case aluminium
    case steel
    case none
    
    var id: String {
        rawValue
    }
}

enum ProductFinish: String, Hashable, CaseIterable {
    case starlight
    case midnight
    case gold
    case silver
    case graphite
    case black
    case red = "product-red"
    case none
    
    var id: String {
        rawValue
    }
}

enum ProductBandType: String, Hashable, CaseIterable {
    case sole = "solo-loop"
    case braided = "braided-solo-loop"
    case sportBand = "sport-band"
    case sportLoop = "sport-loop"
    case nike
    case leather
    case steel
    case nylon
    case none
    
    var id: String {
        rawValue
    }
}
