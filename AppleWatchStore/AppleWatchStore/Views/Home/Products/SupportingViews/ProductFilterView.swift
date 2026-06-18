//
//  ProductFilterView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/18/24.
//

import SwiftUI
import SwiftData

struct ProductFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ProductsFilter.self) private var filter
    @Query var productFilters: [ProductFilter]
    @State private var sections: [[ProductFilter]] = []
    
    let categories = ["material", "finish", "band"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
            }
            .background(Color(.baseBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    closeButton
                }
            }
            .navigationTitle("nav.productFilters")
            .task {
                filter.fetchSaved(filters: productFilters)
                
                categories.forEach { category in
                    let filtersByCategry = productFilters.filter { $0.category == category }
                    
                    sections.append(filtersByCategry)
                }
            }
            .safeAreaInset(edge: .bottom) {
                filterStatus
            }
        }
    }
    
    var content: some View {
        VStack(spacing: 48) {
            ForEach($sections, id: \.self) { $section in
                ProductFilterSectionView(items: $section)
            }
        }
        .padding(.top, 40)
    }
    
    var filterStatus: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 124)
                .background(.ultraThinMaterial, in: Rectangle())
            
            Button(action: { self.dismiss.callAsFunction() }, label: {
                Text("FILTER (^[\(filter.filterCount) ITEM](inflect:true))")
                    .condensedLowercased(.medium, size: 24)
                    .foregroundStyle(.white)
            })
            .buttonStyle(.customBorderedBlack)
            .padding(.horizontal, 20)
        }
        .offset(y: 32)
        .frame(height: 124)
    }
    
    var closeButton: some View {
        Button(action: { self.dismiss.callAsFunction() }, label: {
            Text("button.close")
                .foregroundStyle(.primary)
                .condensed(.bold, size: 20)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    ProductFilterView()
}
