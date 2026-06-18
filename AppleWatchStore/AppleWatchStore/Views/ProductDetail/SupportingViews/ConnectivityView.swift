//
//  ConnectivityView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct ConnectivityView: View {
    @Environment(ProductDetail.self) var productDetail
    
    var body: some View {
        VStack {
            SectionHeader(title: "section.connectivity")
                .padding(.bottom)
            
            HStack {
                ForEach(ProductCellularType.allCases) { item in
                    Button(action: {
                        productDetail.selectedGPSCellular = item
                    }) {
                        if item != .none {
                            WifiCellularView(type: item)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(productDetail.selectedGPSCellular == item ? .baseStroke : .baseMediumGrey,
                                                lineWidth: productDetail.selectedGPSCellular == item ? 2 : 1)
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    ConnectivityView()
        .environment(ProductDetail())
}
