//
//  GridProductItem.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/13/24.
//

import SwiftUI

struct GridProductItem: View {
    let product: Product
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ZStack {
                    Image(product.band)
                        .resizable()
                        .frame(width: 250, height: 250)
                    
                    Image(product.face)
                        .resizable()
                        .frame(width: 250, height: 250)
                }
                
                VStack {
                    Text("€").ultraLight() + Text(product.displayPrice).heavy()
                    
                    Text(product.title)
                        .condensed(.bold, size: 16)
                    
                    Text(product.bandDisplay)
                        .condensed(.light, size: 16)
                }
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
                
                HStack {
                    ForEach(0..<4) { _ in
                        Circle()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.bottom)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.gradient)
        )
        .overlay(alignment: .topTrailing) {
            Constants.heart.onLongPressGesture(minimumDuration: 0.24) {
                product.isFavorite.toggle()
            }
            .symbolVariant(product.isFavorite ? .fill : .none)
            .font(.system(size: 24))
            .padding(.top, 4)
        }
    }
}

//#Preview {
//    GridProductItem(product: Product.default)
//}
