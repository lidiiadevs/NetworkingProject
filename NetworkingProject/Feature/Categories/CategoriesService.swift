//
//  CategoriesService.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 9/10/26.
//

import Foundation


protocol CategoriesService {
    func fetch() async throws -> [String]
}

struct DefaultCategoriesService: CategoriesService { //it isn't swappable, reusable, so we use protocol
    
//    let baseURL: URL
    let client: APIClient
    
    init(baseURL: URL = URL(string: "https://dummyjson.com")!) {
        self.client = APIClient(baseURL: baseURL)
    }
    
    func fetch() async throws -> [String] {
        return try await client.fetch(endpoint: CategoriesEndpoint())
//        let endpoint = CategoriesEndpoint()
//        let request = try endpoint.makeRequest(baseURL: baseURL)
//        
//        return try await client.fetch(request: request, type: [String].self)
    }
}
