//
//  CardView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/11/24.
//

import SwiftUI

struct CardView: View {
    let product: FeaturedProduct
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Constants.gradient)
                    .frame(height: 248.0 / 1.6)
                
                VStack {
                    Image(product.image)
                    
                    VStack {
                        VStack(alignment: .center, spacing: -4) {
                            Text(product.title)
                                .condensed(.light, size: 20)
                            
                            Text(product.description)
                                .condensedLowercased(.bold, size: 24)
                        }
                        
                        Button(action: {
                            
                        }) {
                            Text("button.shop")
                                .condensedLowercased(.medium, size: 24)
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.customBorderedBlack)
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    CardView(product: FeaturedProduct.default)
}
