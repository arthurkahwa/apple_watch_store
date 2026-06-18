//
//  WristSizesView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct WristSizesView: View {
    @Environment(ProductDetail.self) var productDetail
    
    let product: Product
    
    var sortedSizes: [WristSize] {
        get {
            product.wristSizes.sorted(by: { $0.order < $1.order })
        }
        set {
            product.wristSizes = newValue
        }
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: "section.wristSizes")
                .padding(.bottom)
            
            ForEach(sortedSizes) { size in
                Button(action: {
                    productDetail.selectedWristSSize = size
                }) {
                    WristItemView(item: size)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(productDetail.selectedWristSSize == size ? .baseStroke :.baseMediumGrey,
                                        lineWidth: productDetail.selectedWristSSize == size ? 2 : 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

//#Preview {
//    WristSizesView()
//}
