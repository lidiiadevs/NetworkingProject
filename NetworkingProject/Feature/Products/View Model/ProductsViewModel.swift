//
//  ProductsViewModel.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/15/26.
//

import Foundation

@Observable
class ProductsViewModel {
    
    enum LoadingState {
        case initial
        case loading
        case loadingMore
        case loaded
        case initialLoadError(String)
        case loadMoreError(String)
        
        var canLoad: Bool {
            switch self {
            case .initial:
                true
            case .loading:
                false
            case .loaded:
                true
            case .loadingMore:
                false
            case .initialLoadError(let string):
                true
            case .loadMoreError(let string):
                true
            }
        }
    }
    
    private(set) var products: [Product] = []
    var loadingState: LoadingState = .initial
    private var totals: Int? = nil
    private let service: ProductsService
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func initialFetchProducts() async {
        //it needs to be done only once, so
        guard products.isEmpty else { return }
        
        loadingState = .loading
        
       // defer { isLoading = false }
        
        do {
//            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: 0, limit: 10)
            self.products = response.products
            self.totals = response.total
            self.loadingState = .loaded
        } catch {
            self.loadingState = .initialLoadError(error.localizedDescription)
        }
    }
    
    func fetchMore() async {
        //to prevent unnecessary fetch
        guard totals != products.count, loadingState.canLoad else { return }
        print("load more ...")
      
        loadingState = .loadingMore
        
        do {
//            try await Task.sleep(for: .milliseconds(500))
            
            let response = try await service.fetch(skip: products.count, limit: 10)
            
            self.totals = response.total
            self.products.append(contentsOf: response.products)
            self.loadingState = .loaded
        } catch {
            self.loadingState = .loadMoreError(error.localizedDescription)
          //  self.errorMessage = error.localizedDescription
        }
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.initialFetchProducts()
}

