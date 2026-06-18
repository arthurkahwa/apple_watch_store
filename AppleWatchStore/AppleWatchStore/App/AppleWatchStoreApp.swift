//
//  AppleWatchStoreApp.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/10/24.
//

import SwiftUI
import SwiftData

@main
struct AppleWatchStoreApp: App {
    @State private var manager = DataManager()
    @State private var filter = ProductsFilter()
    @State private var productDetail = ProductDetail()
    @State private var cart = ShoppingCart()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(manager)
                .environment(filter)
                .environment(productDetail)
                .environment(cart)
                .modelContainer(manager.modelContainer)
                .task {
                    await manager.initializeData()
                }
        }
    }
}
