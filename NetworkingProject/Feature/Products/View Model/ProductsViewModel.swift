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
    var isLoading: Bool = false
    var totals: Int? = nil
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func initialFetchProducts() async {
        //it needs to be done only once, so
        guard products.isEmpty else { return }
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            let response = try await service.fetch(skip: 0, limit: 10)
            self.products = response.products
            self.totals = response.total
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchMore() async {
        //to prevent unnecessary fetch
        guard totals != products.count, !isLoading  else { return }
        print("load more ...")
      
        isLoading = true
        defer { isLoading = false }
       // guard products.last?.id == id else { return }
        
//        guard products.suffix(3).contains(where: { $0.id == id }) else
//        { return }
        do {
           // try await Task.sleep(for: .seconds(1))
            
            let response = try await service.fetch(skip: products.count, limit: 10)
            
            self.totals = response.total
            self.products.append(contentsOf: response.products)
        } catch {
            self.errorMessage = error.localizedDescription
            print(self.errorMessage ?? "")
        }
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.initialFetchProducts()
}

