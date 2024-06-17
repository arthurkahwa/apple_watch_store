//
//  PopularSection.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/13/24.
//

import SwiftUI

struct PopularSection: View {
    var body: some View {
        VStack {
            SectionHeader(title: "Popular", icon: "slider.horizontal.3")
            
            LazyVGrid(columns: Constants.columns, spacing: 20) {
                ForEach(0..<4) { _ in
                    NavigationLink {
                        
                    } label: {
                        GridProductItem()
                    }

                }
            }
        }
    }
}

#Preview {
    PopularSection()
}