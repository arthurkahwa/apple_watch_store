//
//  WideProductItem.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/19/24.
//

import SwiftUI

struct WideProductItem: View {
    let product: Product
    
    var body: some View {
        ZStack {
            HStack(alignment: .bottom, spacing: 0) {
                VStack(spacing: 4) {
                    ZStack {
                        Image(product.band)
                            .resizable()
                            .frame(width: 250, height: 250)
                        
                        Image(product.face)
                            .resizable()
                            .frame(width: 250, height: 250)
                    }
                    .frame(width: 160)
                    .padding(.trailing)
                    
                    HStack {
                        ForEach(0..<3) { _ in
                            Circle()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: -4) {
                    Text("€").ultraLight() + Text(product.displayPrice).heavy()
                    
                    VStack(alignment: .trailing) {
                        Text(product.title)
                            .condensed(.bold, size: 16)
                        
                        
                        Text(product.bandDisplay)
                            .condensed(.light, size: 16)
                    }
                }
                .foregroundStyle(.primary)
                .padding(.bottom, 4)
            }
        }
        .padding()
        .frame(height: 220, alignment: .bottom)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.gradient)
        )
        .frame(maxWidth: .infinity, alignment: .bottom)
        .overlay(alignment: .topTrailing) {
            Constants.heart.onLongPressGesture(minimumDuration: 0.24) {
                product.isFavorite.toggle()
            }
            .symbolVariant(product.isFavorite ? .fill : .none)
            .font(.system(size: 24))
            .padding(.top, 4)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    WideProductItem()
//}
