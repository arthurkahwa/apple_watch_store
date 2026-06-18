//
//  ProductDetailDescriptionView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct ProductDetailDescriptionView: View {
    let product: Product
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.detailTitle)
                    .condensed(.bold, size: 36)
                    .lineLimit(2)
                
                HStack(alignment: .center) {
                    Image(systemName: "star")
                        .font(.system(size: 16))
                        .symbolVariant(.fill)
                        .foregroundStyle(.baseGold)
                    
                    Text(String(format: product.reviews.count > 0 ? "%.1f" : "0.0", product.ratingAverage))
                        .condensed(.bold, size: 24)
                    
                    Button(action: {}) {
                        Text("^[\(product.reviews.count) Reviews](inflect: true)")
                            .condensed(.light, size: 20)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        AddProductReview(product: product)
                    } label: {
                        Text("product.addReview")
                            .condensed(.light, size: 20)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 4)
                
                Text(product.desc)
                    .condensed(.light, size: 20)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ProductDetailDescriptionView()
//}
