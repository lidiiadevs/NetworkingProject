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
            self.products = try await service.fetch(skip: 0, limit: 10)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchMore() async {
        //TODO
       // guard products.last?.id == id else { return }
        
//        guard products.suffix(3).contains(where: { $0.id == id }) else
//        { return }
        
        print("load more ...")
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.fetchProducts()
}

