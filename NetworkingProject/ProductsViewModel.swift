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
    let client = APIClient()
    
    func fetchProducts() async {
        //STEP 1
        let request = URLRequest(
            url: URL(string: "https://dummyjson.com/products?limit=10&skip=0")!)
        //URLRequest makes a little bit more adaptable for get/post/delete instead of URL
        do {
            let productsResponse = try await client.fetch(request: request, type: ProductResponse.self)
            self.products = productsResponse.products
            print("success \(products.count)")
        } catch {
            print(error)
        }
    }
}

enum APIError: Error {
    case invalidResponse
    case requestFailed(statusCode: Int, message: String?)
    case networkError(Error)
    case taskCancellation
}

struct ServerError: Decodable { //JSONDecoder can only decode types conforming to Decodable
    let message: String
}

import Playgrounds

#Playground {
    let vm = ProductsViewModel()
    await vm.fetchProducts()
}

