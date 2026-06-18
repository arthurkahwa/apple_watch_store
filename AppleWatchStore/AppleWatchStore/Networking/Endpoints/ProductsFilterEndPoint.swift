//
//  ProductsFilterEndPoint.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/24/24.
//

import Foundation

enum ProductsFilterEndPoint {
    case all
}

extension ProductsFilterEndPoint: EndPoint {
    var path: String {
        switch self {
        case .all:
            return "/product-filters"
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
