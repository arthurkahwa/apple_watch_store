//
//  FeaturedProduct.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/26/24.
//

import Foundation
import SwiftUI

struct FeaturedProduct: Identifiable {
    let id = UUID().uuidString
    let image: String
    let title: String
    let description: String
    
    static var `default`: FeaturedProduct {
        FeaturedProduct(image: "defaultProduct.image",
                                title: "defaultProduct.series",
                                description: "defaultProduct.description")
    }
}
