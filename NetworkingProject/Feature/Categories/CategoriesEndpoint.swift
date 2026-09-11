//
//  CategoriesEndpoint.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 9/10/26.
//


import Foundation

struct CategoriesEndpoint: Endpoint {
    typealias Response = [String]
    
    var path: String = "/products/category-list"
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] { [] }
}