//
//  Constants.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/11/24.
//

import Foundation
import SwiftUI

enum Constants {
    static let gradient = Gradient(stops: [
        .init(color: Color(.baseGraedientTop), location: 0.2),
        .init(color: Color(.baseGradientBottom), location: 0.5)
    ])
    
    static let filterColumns = [
        GridItem(.adaptive(minimum: 120)),
        GridItem(.adaptive(minimum: 120))
    ]
    
    static let columns = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
    
    static var heart: some View {
        Image(systemName: "heart")
            .font(.system(size: 24))
            .padding(.trailing, 20)
            .padding(.top, 10)
    }
    
    static let featuredProducts: [FeaturedProduct] = [
        FeaturedProduct(image: "watch-card-40-ultra", title: String(localized: "featured.ultra.title"), description: String(localized: "featured.ultra.description")),
        FeaturedProduct(image: "watch-card-40-se", title: String(localized: "featured.se.title"), description: String(localized: "featured.se.description")),
        FeaturedProduct(image: "watch-card-40-s8", title: String(localized: "featured.s8.title"), description: String(localized: "featured.s8.description")),
        FeaturedProduct(image: "watch-card-40-hermes", title: String(localized: "featured.hermes.title"), description: String(localized: "featured.hermes.description"))
    ]
    
    static let categories: [(name: String, icon: String)] = [
        (name: String(localized: "category.bands"), icon: "icon-watch-band"),
        (name: String(localized: "category.case"), icon: "icon-watch-case"),
        (name: String(localized: "category.headphones"), icon: "icon-headphones"),
        (name: String(localized: "category.health"), icon: "icon-fitness"),
        (name: String(localized: "category.power"), icon: "icon-powercables"),
        (name: String(localized: "category.chargers"), icon: "icon-wirelesschargers")
    ]
}
