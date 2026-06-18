//
//  FavoritesView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(filter: #Predicate<Product> { product in
        product.isFavorite == true
    })
    var products: [Product]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 60) {
                    ForEach(products) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            WideProductItem(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 60)
            }
            .background(Color.baseBackground)
            .navigationTitle("nav.myFavorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    FavoritesView()
}
