//
//  RatingReview.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/3/24.
//

import SwiftUI

struct RatingReview: View {
    @Binding var rating: Float
    
    var text = ""
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var body: some View {
        HStack {
            if text.isNotEmpty {
                Text(text)
            }
            
            ForEach(1..<maxRating + 1, id: \.self) { num in
                image(for: Float(num))
                    .foregroundStyle(num > Int(rating) ? .baseRatingOff : .baseRatingOn)
                    .onTapGesture {
                        rating = Float(num)
                    }
            }
        }
    }
    
    func image(for number: Float) -> Image {
        if number > rating {
            return offImage ?? onImage
        }
        else {
            return onImage
        }
    }
}

#Preview {
    RatingReview(rating: .constant(4))
}
