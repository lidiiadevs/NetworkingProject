//
//  APIError.swift
//  NetworkingProject
//
//  Created by Lidiia Diachkovskaia on 8/21/26.
//
import Foundation

enum APIError: Error, LocalizedError { //LocalizedError so u can write an enum for the error description
    case invalidResponse
    case requestFailed(statusCode: Int, message: String?)
    case networkError(Error)
    case taskCancellation
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Something went wrong. Please try again."
        case .networkError(_):
            "Something went wrong. Please try again."
        case .requestFailed(_, _):
            "Something went wrong. Please try again."
        case .taskCancellation:
            "Task was cancelled"
        case .invalidURL:
            "Invalid URL"
        }
    }
}

struct ServerError: Decodable { //JSONDecoder can only decode types conforming to Decodable
    let message: String
}
