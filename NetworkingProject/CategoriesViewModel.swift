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
    let client = APIClient()
    
    func fetchCategories() async {
        //STEP 1
        let request = URLRequest(url: URL(string: "https://dummyjson.com/products/category-list")!)
        
        do {
            let categories = try await client.fetch(request: request, type: [String].self)
            print("success \(categories.count)")
        } catch {
            print(error)
        }
    }
}
