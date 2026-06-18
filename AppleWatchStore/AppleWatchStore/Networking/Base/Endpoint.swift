//
//  Endpoint.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

protocol EndPoint {
    var schema: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var port: Int { get }
}

extension EndPoint {
    var schema: String {
        return "http"
    }
    
    var host: String {
        return "127.0.0.1"
    }
    
    var port: Int {
        return 3000
    }
}
