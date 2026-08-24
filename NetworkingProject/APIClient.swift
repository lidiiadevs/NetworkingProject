//
//  APIClient.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/20/26.
//

import Foundation

struct APIClient {
    
    @concurrent //this struct was running in a main thread but with @concurrent we are switching to a background actor
    func fetch<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        //STEP 1
        //        let request = URLRequest(url: URL(string: "https://dummyjson.com/products/category-list")!)
        //      //  URLRequest makes a little bit more adaptable for get/post/delete instead of URL
        
        let data: Data
        let response: URLResponse
    
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw APIError.taskCancellation
        } catch is CancellationError {
            throw APIError.taskCancellation
        } catch {
            throw APIError.networkError(error)
        }
        
        //STEP 2
        guard let httpResponse = response as? HTTPURLResponse else {
            print("unknown response")
            throw APIError.invalidResponse
        } //casting type into HTTP response
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("error \(httpResponse.statusCode)")
            
            let serverError = try JSONDecoder().decode(ServerError.self, from: data)
            
            throw APIError.requestFailed(statusCode: httpResponse.statusCode, message: serverError.message)
            
            //if want to extand
            // 404 - does not exist
            // 401 - auth problems
            // 429 - rate limited
            // 500...599 - server
        }
        
        //STEP 3 - is decoding
        print("REQUEST:", request.url?.absoluteString ?? "")
        print("RAW JSON:", String(data: data, encoding: .utf8) ?? "")
        return try JSONDecoder().decode(type, from: data)
    }
}
