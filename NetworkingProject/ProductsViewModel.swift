//
//  ProductsViewModel.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/15/26.
//

import Foundation

@Observable
class ProductsViewModel {
    var products: [Product] = []
    let service: ProductsService
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func fetchProducts() async {
        do {
            self.products = try await service.fetch(skip: 10, limit: 10)
        } catch {
            print(error)
        }
    }
}

protocol ProductsService {
    func fetch(skip: Int, limit: Int) async throws -> [Product]
    
}

struct DefaultProductsService: ProductsService {
    let client = APIClient()
    
    func fetch(skip: Int, limit: Int) async throws -> [Product] {
        let request = URLRequest(
            url: URL(string: "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)")!)
        
        return try await client.fetch(request: request, type: ProductResponse.self).products
    }
}

struct MockProductsService: ProductsService {
    
    func fetch(skip: Int, limit: Int) async throws -> [Product] {
        [Product.example]
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.fetchProducts()
}

