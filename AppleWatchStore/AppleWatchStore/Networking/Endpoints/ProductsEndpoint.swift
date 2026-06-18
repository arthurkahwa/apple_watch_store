//
//  ProductsEndpoint.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

enum ProductsEndpoint {
    case all
}

extension ProductsEndpoint: EndPoint {
    var path: String {
        switch self {
        case .all:
            return "/products"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .all:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .all:
            return ["Content-Type": "application/json;charset=utf-8"]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .all:
            return nil
        }
    }
}
