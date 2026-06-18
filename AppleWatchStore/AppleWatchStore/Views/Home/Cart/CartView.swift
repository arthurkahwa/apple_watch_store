//
//  CartView.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/17/24.
//

import SwiftUI
import PassKit

struct CartView: View {
    @Environment(ShoppingCart.self) var cart
    
    let paymentRequest = PKPaymentRequest()
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(cart.products) { product in
                    casrtItem(product: product)
                }
                .onDelete(perform: cart.remove(at:))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                .background(Color.baseBackground)
            }
            .overlay {
                if cart.products.isEmpty {
                    ContentUnavailableView {
                        Label("cart.empty.title", systemImage: "cart.fill")
                    } description: {
                        Text("cart.empty.description")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                cartTotals
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("nav.myBag")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.baseBackground)
        }
    }
    
    
    func casrtItem(product: CartProduct) -> some View {
        HStack(alignment: .bottom, spacing: 20) {
            watchImage(product: product)
            
            watchDetails(product: product)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
    
    func watchImage(product: CartProduct) -> some View {
        HStack {
            ZStack {
                Image(product.band)
                    .resizable()
                
                Image(product.face)
                    .resizable()
            }
            .frame(width: 268, height: 268)
            .padding(.bottom, 25)
            .frame(width: 180)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Constants.gradient)
            )
        }
    }
    
    func watchDetails(product: CartProduct) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(product.productSeries)
                    .condensed(.black, size: 20)
                    .lineLimit(2)
                
                Group {
                    Text("€").ultraLight() + Text(product.displayPrice).heavy()
                }
                
                Text(product.caseSize)
                    .condensed(.medium, size: 16)
                
                Text(String(format: String(localized: "cart.case"), product.caseMaterial, product.caseFinish))
                    .condensed(.medium, size: 16)
                
                Text("\(product.bandColor) \(product.bandName)")
                    .condensed(.light, size: 16)
                
                Text(String(format: String(localized: "cart.loopSize"), product.wristSize))
                    .condensed(.light, size: 16)
                
                HStack {
                    Image(.iconWifi)
                    
                    Image(.dlTelekomLogo)
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    Image(.icon5G)
                        .opacity(product.cellularType == .wifiAndCellular ? 1 : 0)
                    
                }
            }
            
            HStack {
                Button(action: {
                    cart.decrement(product: product)
                }, label: {
                    Image(systemName: "minus")
                        .font(.system(size: 20))
                        .bold()
                        .padding(8)
                        .foregroundStyle(.white)
                })
                .frame(width: 40)
                .buttonStyle(.customBorderedBlack)
                
                Text("\(product.quantity)")
                    .condensed(.heavy, size: 40)
                
                Button(action: {
                    cart.increment(product: product)
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16))
                        .bold()
                        .padding(4)
                        .foregroundStyle(.white)
                })
                .frame(width: 32)
                .buttonStyle(.customBorderedBlack)
            }
        }
        .frame(maxHeight: 280)
    }
    
    var cartTotals: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 200)
                .background(
                    .regularMaterial, in: Rectangle()
                )
            
            VStack {
                HStack {
                    Text("cart.subtotal")
                        .condensed(.bold, size: 20)
                    
                    Spacer()
                    
                    Text("€").ultraLight() + Text(String(format: "%.2f", cart.total)).customBold(size: 20)
                }
                
                HStack {
                    Text("cart.tax")
                        .condensed(.bold, size: 20)
                    
                    Spacer()
                    
                    Text("€").ultraLight() + Text(String(format: "%.2f", cart.getTax())).customBold(size: 20)
                }
                
                Divider()
                
                VStack {
                    HStack {
                        Text("cart.total")
                            .condensed(.black, size: 24)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", cart.getOrderTotal()))
                            .customBold(size: 48)
                            .overlay(alignment: .topLeading) {
                                Text("€").ultraLight(size: 20)
                                    .offset(x: -10, y: 10)
                            }
                    }
                    
                    PayWithApplePayButton (
                        .buy,
                        request: paymentRequest,
                        onPaymentAuthorizationChange: authorizationChange
                    ) {}
                    .frame(height: 52)
                    .payWithApplePayButtonStyle(.black)
                }
            }
            .padding()
        }
        .frame(height: 200)
    }
    
    func authorizationChange(phase: PayWithApplePayButtonPaymentAuthorizationPhase) {
        cart.pay()
    }
}

#Preview {
    CartView()
        .environment(ShoppingCart())
}
