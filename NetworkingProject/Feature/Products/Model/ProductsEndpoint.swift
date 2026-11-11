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
        var sortField: SortField?
    }
    
    var path: String {
        if let category = configuration.category {
            "/products/category/\(category)"
        } else if configuration.searchText != nil {
            "/products/search"
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
        
        // search only applies on /products/search path
        // when category is set, query is ignored
        if configuration.category == nil {
            let searchText = configuration.searchText
            items.append(.init(name: "q", value: searchText))
        }
        
        if let sortField = configuration.sortField {
            switch sortField {
            case .title:
                items.append(URLQueryItem(name: "sortBy", value: "title"))
            case .priceAsc:
                items.append(URLQueryItem(name: "sortBy", value: "price"))
                items.append(URLQueryItem(name: "sortBy", value: "asc"))
            case .priceDesc:
                items.append(URLQueryItem(name: "sortBy", value: "price"))
                items.append(URLQueryItem(name: "sortBy", value: "desc"))
            case .rating:
                items.append(URLQueryItem(name: "sortBy", value: "rating"))
            case .stock:
                items.append(URLQueryItem(name: "sortBy", value: "stock"))
            case .discount:
                items.append(URLQueryItem(name: "sortBy", value: "discount"))
            }
            
//            items.append(URLQueryItem(name: "sortBy", value: <#T##String?#>))
//            items.append(URLQueryItem(name: "sortBy", value: <#T##String?#>))
        }
        
//        if let searchQuery {
//            items.append(.init(name: "q", value: searchQuery))
//        }
        
        return items
    }
}
