//
//  HttpClient.swift
//  AppleWatchStore
//
//  Created by Arthur Nsereko Kahwa on 6/21/24.
//

import Foundation

protocol HttpClient {
    func request<T: Decodable>(endpoint: EndPoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HttpClient {
    func request<T: Decodable>(endpoint: EndPoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = endpoint.schema
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        
        guard let url = urlComponents.url else { return .failure(.invalidURL) }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else { return .failure(.invalidResponse) }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decodable)
                }
                
                return .success(decodedResponse)
                
            case 401:
                return .failure(.invalidResponse)
                
            default:
                return .failure(.invalidResponse)
            }
        }
        catch {
            return .failure(.invalidURL)
        }
    }
}
