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
    var errorMessage: String?
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func fetchProducts() async {
        do {
            self.products = try await service.fetch(skip: 10, limit: 10)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.fetchProducts()
}

