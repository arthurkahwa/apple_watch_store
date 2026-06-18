//
//  DataManager.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/25/24.
//

import Foundation
import Observation
import SwiftData

@Observable
final class DataManager {
    var service = ProductService()
    var filterService = ProductFilterService()
    
    var productData = [ProductData]()
    var filterData = [ProductFilterData]()
    
    var dbInitializationProgress: Bool = false
    
    let modelContainer = try! ModelContainer(for: Product.self, ProductFilter.self, Review.self)
    
    var hasSetupDatabase: Bool {
        didSet {
            UserDefaults.standard.setValue(hasSetupDatabase, forKey: "hasSetupDatabase")
        }
    }
    
    init() {
        self.hasSetupDatabase = UserDefaults.standard.bool(forKey: "hasSetupDatabase")
    }
    
    func initializeData() async {
        guard !hasSetupDatabase else { return }
        
        dbInitializationProgress = true
        
        do {
            productData = try await fetchProducts() ?? []
            filterData = try await fetchFilterDat() ?? []
            
//            dump(productData)
//            dump(filterData)
        }
        catch {
            debugPrint("❌ unable to get roduct r filter data: \(error)")
        }
        
        guard productData.isNotEmpty else { return }
        guard filterData.isNotEmpty else { return }
        
        Task() { @MainActor in
            let products = productData.map { Product(product: $0) }
            let filters = filterData.map { ProductFilter(filter: $0) }
            
            products.forEach { modelContainer.mainContext.insert($0) }
            filters.forEach { modelContainer.mainContext.insert($0) }
            
            dbInitializationProgress = false
            hasSetupDatabase = true
            
            print("‼️ ====== DADTABASE =======")
            dump(products)
            dump(filters)
        }
    }
    
    @MainActor
    func addProductReview(product: Product, data: ReviewData) {
        let review = Review(title: data.title,
                            reviewSummary: data.summary, 
                            rating: data.rating,
                            name: data.name,
                            creationDate: Date.now)
        
        product.reviews.append(review)
        
        modelContainer.mainContext.insert(review)
    }
    
    func fetchProducts() async throws -> [ProductData]? {
        var products: [ProductData] = []
        let results = await service.fetchProducts()
        
        switch results {
        case .success(let result):
            products = result
            return products
            
        case .failure(let error):
            print("❌ error: \(error.localizedDescription)")
            dump(error)
            
            return []
        }
    }
    
    func fetchFilterDat() async throws -> [ProductFilterData]? {
        var filters: [ProductFilterData] = []
        let results = await filterService.fetchProductFilters()
        
        switch results {
        case .success(let result):
            filters = result
            return filters
            
        case .failure(let error):
            print("❌❌ error: \(error.localizedDescription)")
            
            return []
        }

    }
}
