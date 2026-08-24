//
//  APIError.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/21/26.
//


enum APIError: Error {
    case invalidResponse
    case requestFailed(statusCode: Int, message: String?)
    case networkError(Error)
    case taskCancellation
}

struct ServerError: Decodable { //JSONDecoder can only decode types conforming to Decodable
    let message: String
}