//
//  CategorySection.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI

struct CategorySection: View {
    var body: some View {
        VStack(spacing: 20) {
            SectionHeader(title: "section.watchAccessories")
                .padding(.horizontal)
            
            VStack {
                ForEach(Constants.categories, id: \.name) { item in
                    CategoryListItem(item: item)
                }
            }
        }
    }
}

#Preview {
    CategorySection()
}
