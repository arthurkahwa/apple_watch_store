//
//  CaseSizesView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI

struct CaseSizesView: View {
    @Environment(ShoppingCart.self) var cart
    @Environment(ProductDetail.self) var productDetail
    
    let product: Product
    
    var sortedSizes: [CaseSize] {
        get {
            product.caseSizes.sorted(by: { $0.order  < $1.order })
        }
        set {
            product.caseSizes = newValue
        }
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: "section.caseSizes")
                .padding(.bottom)
            
            ForEach(sortedSizes) { size in
                Button(action: {
                    productDetail.selectedCaseSize = size
                }) {
                    SizeItemView(item: size)
                        .contentShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(productDetail.selectedCaseSize == size ? .baseStroke : .baseMediumGrey,
                                        lineWidth: productDetail.selectedCaseSize == size ? 2 : 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

//#Preview {
//    CaseSizesView()
//}
