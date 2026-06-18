//
//  Review.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/3/24.
//

import Foundation
import SwiftData

@Model
final class Review {
    @Attribute(.unique)
    var id: String
    
    var title: String
    var reviewSummary: String
    var rating: Float
    var name: String
    var creationDate: Date

    @Relationship(inverse: \Product.reviews)
    var product: Product?
    
    init(title: String, reviewSummary: String, rating: Float, name: String, creationDate: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.reviewSummary = reviewSummary
        self.rating = rating
        self.name = name
        self.creationDate = creationDate
    }
    
}
