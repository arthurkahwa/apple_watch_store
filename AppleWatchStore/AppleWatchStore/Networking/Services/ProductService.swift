//
//  ProductService.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

protocol ProductServiceable {
    func fetchProducts() async -> Result<[ProductData], RequestError>
}

struct ProductService: HttpClient, ProductServiceable {
    func fetchProducts() async -> Result<[ProductData], RequestError> {
        return await request(endpoint: ProductsEndpoint.all, responseModel: [ProductData].self)
    }
}
