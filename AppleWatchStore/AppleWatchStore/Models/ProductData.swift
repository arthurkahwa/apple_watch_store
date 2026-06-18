//
//  ProductData.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

class ProductData: Identifiable, Codable {
    let id: String
    let isFeatured: Bool
    let bandDisplay: String
    let bandType: String
    let series: String
    let seriesDisplay: String
    let materialDisplay: String
    let materialType: String
    let finishDisplay: String
    let finishType: String
    let bandColorType: String
    let bandColorDisplay: String
    let collection: String
    let collectionType: String
    let image: String
    let description: String
    let caseSizes: [CaseSizeData]
    let wristSizes: [WristSizeData]
    var isFavorite = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case isFeatured = "featured"
        case bandDisplay = "band-display"
        case bandType = "band-type"
        case series
        case seriesDisplay = "series-display"
        case finishDisplay = "finish-display"
        case finishType = "finish-type"
        case materialDisplay = "material-display"
        case materialType = "material-type"
        case collection
        case collectionType = "collection-type"
        case bandColorType = "band-color-type"
        case bandColorDisplay = "band-color-display"
        case image
        case description
        case caseSizes = "case-sizes"
        case wristSizes = "wrist-sizes"
    }
    
    init(id: String, isFeatured: Bool, bandDisplay: String, bandType: String, series: String, seriesDisplay: String, materialDisplay: String, materialType: String, finishDisplay: String, finishType: String, bandColorType: String, bandColorDisplay: String, collection: String, collectionType: String, image: String, description: String, caseSizes: [CaseSizeData], wristSizes: [WristSizeData], isFavorite: Bool = false) {
        self.id = id
        self.isFeatured = isFeatured
        self.bandDisplay = bandDisplay
        self.bandType = bandType
        self.series = series
        self.seriesDisplay = seriesDisplay
        self.materialDisplay = materialDisplay
        self.materialType = materialType
        self.finishDisplay = finishDisplay
        self.finishType = finishType
        self.bandColorType = bandColorType
        self.bandColorDisplay = bandColorDisplay
        self.collection = collection
        self.collectionType = collectionType
        self.image = image
        self.description = description
        self.caseSizes = caseSizes
        self.wristSizes = wristSizes
        self.isFavorite = isFavorite
    }
}

extension ProductData {
    static var `default`: ProductData {
        ProductData(id: "unique-identifier-solo-loop-band",
                    isFeatured: false,
                    bandDisplay: "Sport Loop",
                    bandType: "Sports Loop",
                    series: "se",
                    seriesDisplay: "Sport Union SE",
                    materialDisplay: "Aluminium",
                    materialType: "Aluminium",
                    finishDisplay: "Silver",
                    finishType: "Silver",
                    bandColorType: "midnight",
                    bandColorDisplay: "midnight",
                    collection: "Apple Watch",
                    collectionType: "apple-watch",
                    image: "sport-band-olive",
                    description: "The aluminum case is lightweight and made from 100 percent recycled aerospace-grade alloy. The Sport Loop is made from a soft and breathable double-layer nylon weave, with a hook-and-loop fastener for quick and easy adjustment.",
                    caseSizes: [CaseSizeData.default],
                    wristSizes: [WristSizeData.default])
    }
}
