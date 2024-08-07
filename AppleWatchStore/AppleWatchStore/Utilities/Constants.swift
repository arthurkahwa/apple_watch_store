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
        FeaturedProduct(image: "watch-card-40-ultra", title: "Apple Watch Ultra", description: "Ready for adventure"),
        FeaturedProduct(image: "watch-card-40-se", title: "Apple Watch SE", description: "Capable and affordable"),
        FeaturedProduct(image: "watch-card-40-s8", title: "Apple Watch Series 8", description: "Advanced health features"),
        FeaturedProduct(image: "watch-card-40-hermes", title: "Apple Watch Hermes", description: "Fashion Forward")
    ]
    
    static let categories: [(name: String, icon: String)] = [
        (name: "Apple Watch Bands", icon: "icon-watch-band"),
        (name: "Case And Protection", icon: "icon-watch-case"),
        (name: "Headphones And Speakers", icon: "icon-headphones"),
        (name: "Health And Fitness", icon: "icon-fitness"),
        (name: "Power And Cables", icon: "icon-powercables"),
        (name: "Wireless Chargers", icon: "icon-wirelesschargers")
    ]
}
