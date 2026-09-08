//
//  ProductsService.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 9/2/26.
//

import Foundation

protocol ProductsService {
    func fetch(skip: Int, limit: Int) async throws -> [Product]
    
}


struct DefaultProductsService: ProductsService {
    let client = APIClient()
    let baseURL: URL
    
    init(baseURL: URL = URL(string: "https://dummyjson.com")!) {
        self.baseURL = baseURL
    }
    
    func fetch(skip: Int, limit: Int) async throws -> [Product] {
        let endpoint = ProductsEndpoint(limit: limit, skip: skip)
        let request = try endpoint.makeRequest(baseURL: baseURL)
      //  URLRequest(url: URL(string: "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)")!)
        
        return try await client.fetch(request: request, type: ProductResponse.self).products
    }
}


struct MockProductsService: ProductsService {
    let error: APIError?
    let result: [Product]

    init(error: APIError? = nil, result: [Product] = [Product.example]) {
        self.error = error
        self.result = result
    }
    
    func fetch(skip: Int, limit: Int) async throws -> [Product] {
        if let error {
            throw error
        } else {
            result
        }
    }
}
