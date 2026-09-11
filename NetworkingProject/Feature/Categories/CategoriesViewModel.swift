//
//  CategoriesViewModel.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/20/26.
//

import Foundation

@Observable
class CategoriesViewModel {
    
    var categories: [String] = []
    let service: CategoriesService
    
    init(service: CategoriesService = DefaultCategoriesService() ) {
        self.service = service
    }
    
    func fetchCategories() async {
      //  let request = URLRequest(url: URL(string: "https://dummyjson.com/products/category-list")!)
        do {
            categories = try await service.fetch()
            print("success \(categories.count)")
        } catch {
            print(error)
        }
    }
}



