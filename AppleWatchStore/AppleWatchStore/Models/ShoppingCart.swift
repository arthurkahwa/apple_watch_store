//
//  ShoppingCart.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 7/1/24.
//

import Foundation
import Combine
import SwiftData

@Observable
class ShoppingCart: Identifiable {
    let id = UUID()
    var quantity: Int = 0
    var cartTotal: Double = 0
    var productCount: Int = 0
    
    private (set) var products = [CartProduct]()
    
    let paymentHandler = PaymentHandler()
    var paymentSuccess = false
    
    var total: Double {
        var amount: Double = 0
        
        products.forEach { item in
            let price = item.caseAmount
            let quant = item.quantity
            
            amount += Double(price) * Double(quant)
        }
        
        return amount
    }
    
    var cartQuantity: Int {
        products.count
    }
    
    func increment(product: CartProduct) {
        product.quantity += 1
        update(product: product)
    }
    
    func decrement(product: CartProduct) {
        product.quantity -= 1
        update(product: product)
        
        guard let index = products.firstIndex(where: { $0.id == product.id}) else {
            preconditionFailure("Error: Unable to find a product in the shopping cart")
        }
        
        if product.quantity == 0 {
            products.remove(at: index)
        }
    }
    
    func update(product: CartProduct) {
        guard let index = products.firstIndex(where: { $0.id == product.id}) else {
            preconditionFailure("Error: Unable to fid product in the shopping cart")
        }
        
        products[index] = product
    }
    
    func remove(at offSets: IndexSet) {
        products.remove(atOffsets: offSets)
    }
    
    func getTax() -> Double {
        var gst: Double = 0.0
        
        if total > 0 {
            gst = total * 0.19
        }
    
        return gst
    }
    
    func getOrderTotal() -> Double {
        return Double(total + getTax())
    }
    
    func addCartProduct(product: Product, caseSize: CaseSize?, wristSize: WristSize?, cellType: ProductCellularType) {
        if
            let cSize = caseSize,
            let wSize = wristSize {
            let formatted = wSize.size.replacingOccurrences(of: " ", with: "").lowercased()
            let newProductId = product.createCartProductId(caseSize: cSize.size, wristSize: formatted).lowercased()
            
            guard let cartProduct = products.first(where: { $0.id == newProductId }) else {
                let newProduct = CartProduct(product: product, caseSize: cSize, wristSize: wSize, cellularType: cellType, quantity: 1)
                
                productCount += 1
                
                return products.append(newProduct)
            }
            
            let productItem = cartProduct
            
            if cartProduct.id == newProductId {
                productItem.quantity += 1
                
                update(product: productItem)
            }
        }
    }
    
    func pay() {
        paymentHandler.startPayment(products: products, total: Int(total)) { success in
            if success {
                self.paymentSuccess = success
                
                self.products = []
            }
            else {
                print("❌ payment failure ‼️")
            }
        }
    }
}
