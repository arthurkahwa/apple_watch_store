//
//  ProductsGridView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/18/24.
//

import SwiftUI
import SwiftData

struct ProductsGridView: View {
    @Environment(ProductsFilter.self) private var filter
    @Query var products: [Product]
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: Constants.columns, spacing: 16) {
                    ForEach(filter.filterProducts(products: products)) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            GridProductItem(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top, 2)
        }
    }
}

//#Preview {
//    NavigationStack {
//        ProductsGridView()
//    }
//}
