//
//  RequestError.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

enum RequestError: String, Error {
    case decode
    case invalidURL
    case invalidResponse
    case decodable
    case unknown
    
    var description: String {
        switch self {
            case .decode:
                return String(localized: "error.decode")
            case .invalidURL:
                return String(localized: "error.invalidURL")
            case .decodable:
                return String(localized: "error.decodable")
            case .invalidResponse:
                return String(localized: "error.invalidResponse")
            default:
                return String(localized: "error.unknown")
        }
    }
}
