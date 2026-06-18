//
//  ProductDetailView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/20/24.
//

import SwiftUI
import TipKit

struct ProductDetailView: View {
    @Environment(ProductDetail.self) var productDetail
    @Environment(ShoppingCart.self) var cart
    
    @State var product: Product
    
    var favoriteTip = FavoriteProductTip()
    
    var body: some View {
        ZStack {
            ScrollView {
                header
                
                colors
                
                VStack(spacing: 48) {
                    ProductDetailDescriptionView(product: product)
                    
                    CaseSizesView(product: product)
                    
                    WristSizesView(product: product)
                    
                    ConnectivityView()
                    
                    AppleCareView()
                }
                .padding(.horizontal)
            }
        }
        .task {
            try? Tips.resetDatastore()
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
        .safeAreaInset(edge: .bottom) {
            ZStack {
                addToCart
            }
            .frame(height: 80)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
        }
    }

    var header: some View {
        ZStack(alignment: .bottom)  {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Constants.gradient)
                    .frame(height: 280.0 / 1.1)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            self.product.isFavorite.toggle()
                        }
                    }, label: {
                        Constants.heart
                            .symbolVariant(product.isFavorite ? .fill : .none)
                            .font(.system(size: 24))
                    })
                    .buttonStyle(.plain)
                    .popoverTip(FavoriteProductTip(), arrowEdge: .top)
                }
            }
            
            ZStack {
                Image(product.band)
                    .resizable()
                    .frame(width: 405, height: 405)
                
                Image(product.face)
                    .resizable()
                    .frame(width: 405, height: 405)
            }
        }
        .padding(.horizontal)
    }
    
    var colors: some View {
        VStack {
            SectionHeader(title: "section.brandColors")
                .padding(.horizontal)
            
            HStack {
                ForEach(0 ..< 3) { item in
                    Circle()
                        .fill(.gray)
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var addToCart: some View {
        Button(action: {
            cart.addCartProduct(product: product,
                                caseSize: productDetail.selectedCaseSize,
                                wristSize: productDetail.selectedWristSSize,
                                cellType: productDetail.selectedGPSCellular)
            
            productDetail.hasAddedToCart.toggle()
            
            reset()
        }) {
            Text("button.addToCart")
                .condensedLowercased(.medium, size: 24)
                .foregroundStyle(.white)
        }
        .buttonStyle(.customBorderedBlack)
        .padding(.horizontal)
    }
    
    func reset() {
        productDetail.selectedCaseSize = nil
        productDetail.selectedWristSSize = nil
        productDetail.selectedGPSCellular = .none
        productDetail.selectedAppleCare = .none
        productDetail.hasAddedToCart.toggle()
    }
}

//#Preview {
//    ProductDetailView()
//}
