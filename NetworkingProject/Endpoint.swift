//
//  Endpoint.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 9/2/26.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    
    func makeRequest(baseURL: URL) throws -> URLRequest
}

extension Endpoint {
    
    func makeRequest(baseURL: URL) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}


struct ProductsEndpoint: Endpoint {
    
    let path: String = "/products"
    let method: HTTPMethod = .get
    
    var limit: Int
    var skip: Int
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        return items
    }
}

struct CategoriesEndpoint: Endpoint {
   
    var path: String = "/products/category-list"
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] { [] }
}

