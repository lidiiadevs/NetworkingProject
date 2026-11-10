//
//  ProductsEndpoint.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 9/10/26.
//


import Foundation

struct ProductsEndpoint: Endpoint {
    typealias Response = ProductResponse
    
    struct Configuration: Equatable {
        var searchText: String? = nil
        var category: String?
        var sortField: String
    }
    
    var path: String {
        if let category = configuration.category {
            return "/products/category/\(category)"
        } else if configuration.searchText != nil {
            return "/products/search"
        } else {
            "/products"
        }
        
//        if searchQuery != nil {
//            "/products/search"
//        } else {
//            "/products"
//        }
    }
    
    let method: HTTPMethod = .get
    
    var limit: Int
    var skip: Int
    var configuration: Configuration
//    var searchQuery: String?
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        
        if let searchQuery {
            items.append(.init(name: "q", value: searchQuery))
        }
        
        return items
    }
}
