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
        
        var currentlyLoading: Bool {
            switch self {
            case .loading, .loadingMore: true
            default: false
            }
        }
    }
    
    enum FetchIntents {
        case initial // onAppear - load if empty
        case loadMore // scrolling - load next page
        case search // typing - debounced - reload
        case filterChanged // sheet dismissed - reload
        case retry // error button - reload
        
        var shouldDebounce: Bool { // wait
            self == .search
        }
        
        var resetProducts: Bool {
            switch self {
            case .initial, .loadMore: return false
            case .search, .filterChanged, .retry: return true
            }
        }
    }
    
    private(set) var products: [Product] = []
    var loadingState: LoadingState = .initial
    
    var configuration: ProductsEndpoint.Configuration = .init()
    private var previousConfiguration: ProductsEndpoint.Configuration? = nil
    
    private var totals: Int? = nil
    private let service: ProductsService
    
    private let limits: Int = 20
    
    init(service: ProductsService = DefaultProductsService()) {
        self.service = service
    }
    
    func load(for intent: FetchIntents) async {
        guard canLoad(for: intent) else { return }
        print("load started - \(intent)")
        loadingState = (intent == .initial) ? .loading : .loadingMore
        
        if intent.resetProducts {
            products = []
        }
        
        do {
//            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: products.count,
                                                   limit: limits,
                                                   configuration: configuration)
            self.products = response.products
            self.totals = response.total
            print("load ended - \(intent)")
            self.loadingState = .loaded
            self.previousConfiguration = configuration
        } catch {
            self.loadingState = .initialLoadError(error.localizedDescription)
        }
    }
    
    private func canLoad(for intent: FetchIntents) -> Bool {
        switch intent {
        case .initial:
            products.isEmpty
        case .loadMore:
            !loadingState.currentlyLoading && hasMoreProductsToLoad()
        case .search:
            true
        case .filterChanged:
            true
        case .retry:
            true
        }
    }
    
    func hasMoreProductsToLoad() -> Bool {
        totals != products.count
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
                                                   configuration: configuration)
            self.products = response.products
            self.totals = response.total
            print("initial fetch finished")
            self.loadingState = .loaded
            self.previousConfiguration = configuration
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
                                                   configuration: configuration)
            
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
    
    func fetch() async {
        
//        guard (previousSearch ?? "") != searchQuery else {return}
        guard previousConfiguration != configuration else { return } //prevents more loads
        
//        print("search started for \(searchQuery)")
        
        loadingState = .loading

        products = []

       // defer { isLoading = false }
        do {
//            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.fetch(skip: 0,
                                                   limit: limits,
                                                   configuration: configuration)
            self.products = response.products
            self.totals = response.total
//            print("search finished for \(searchQuery)")
            self.loadingState = .loaded
            self.previousConfiguration = configuration
        } catch {
            self.loadingState = .initialLoadError(error.localizedDescription)
        }
    }
}



import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    
    await vm.load(for: .initial)
    await vm.load(for: .loadMore)
    
    print(vm.loadingState)
    
    print(vm.products)
    for product in vm.products {
        print(product.id)
    }
    
}

