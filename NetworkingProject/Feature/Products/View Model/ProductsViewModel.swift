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
    
    private var previousSearch: String? = nil
    
    private var totals: Int? = nil
    private let service: ProductsService
    
    private let limits: Int = 20
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func initialFetchProducts() async {
        guard products.isEmpty else { return }
        print("initial fetch started")
        loadingState = .loading

       // defer { isLoading = false }
        do {
//            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: 0,
                                                   limit: limits,
                                                   searchQuery: nil)
            self.products = response.products
            self.totals = response.total
            print("initial fetch finished")
            self.loadingState = .loaded
            self.previousSearch = nil
        } catch {
            self.loadingState = .initialLoadError(error.localizedDescription)
        }
    }
    
    func fetchMore() async {
        //to prevent unnecessary fetch
        guard totals != products.count, loadingState.canLoad else { return }
        print("pagination - load more ...")
      
        loadingState = .loadingMore
        
        do {
            //            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: products.count,
                                                   limit: limits,
                                                   searchQuery: previousSearch)
            
            self.totals = response.total
            self.products.append(contentsOf: response.products)
            self.loadingState = .loaded
            print("pagination - load more finished")
        } catch APIError.taskCancellation {
            //ignore
        } catch {
            self.loadingState = .loadMoreError(error.localizedDescription)
          //  self.errorMessage = error.localizedDescription
        }
    }
    
    func fetch(for searchQuery: String) async {
        
        //TODO: exception: load more during paging
        //guard !searchQuery.isEmpty else { return }
        
        guard (previousSearch ?? "") != searchQuery else {return}
        
        print("search started for \(searchQuery)")
        
        loadingState = .loading
        products = []

       // defer { isLoading = false }
        do {
//            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: 0,
                                                   limit: limits,
                                                   searchQuery: searchQuery)
            self.products = response.products
            self.totals = response.total
            print("search finished for \(searchQuery)")
            self.loadingState = .loaded
            self.previousSearch = searchQuery
        } catch {
            self.loadingState = .initialLoadError(error.localizedDescription)
        }
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.initialFetchProducts()
}

