//
//  PopularSection.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/13/24.
//

import SwiftUI
import SwiftData

struct PopularSection: View {
    @Query(filter: #Predicate<Product> { product in
        product.isFeatured == true
    })
    var products: [Product]
    
    var body: some View {
        VStack {
            SectionHeader(title: "section.popular", icon: "slider.horizontal.3")
                .padding(.horizontal)
            
            LazyVGrid(columns: Constants.columns, spacing: 20) {
                ForEach(products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        GridProductItem(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PopularSection()
    }
}
